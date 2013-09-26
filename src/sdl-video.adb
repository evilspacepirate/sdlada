with Interfaces.C;
with Interfaces.C.Strings;

package body SDL.Video is
   package C renames Interfaces.C;

   use type C.int;

   function Is_Screen_Saver_Enabled return Boolean is
      function SDL_Is_Screen_Saver_Enabled return C.int with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_IsScreenSaverEnabled";
   begin
      return (if SDL_Is_Screen_Saver_Enabled = 1 then True else False);
   end Is_Screen_Saver_Enabled;

   function Initialise (Name : in String) return Error_Code is
      function SDL_Video_Init (C_Name : in C.Strings.chars_Ptr) return Error_Code with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_VideoInit";

      C_Str   : C.Strings.chars_Ptr := C.Strings.Null_Ptr;
      Success : Error_Code;
   begin
      if Name /= "" then
         C_Str := C.Strings.New_String (Name);

         Success := SDL_Video_Init (C_Name => C_Str);

         C.Strings.Free (C_Str);
      else
         Success := SDL_Video_Init (C_Name => C.Strings.Null_Ptr);
      end if;

      return Success;
   end Initialise;

   function Total_Drivers (Total : out Positive) return Boolean is
      function SDL_Get_Num_Video_Drivers return C.int with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_GetNumVideoDrivers";

      Num : constant C.int := SDL_Get_Num_Video_Drivers;
   begin
      if Num < 0 then
         Total := Positive'Last;

         return True;
      end if;

      Total := Positive (Total);

      return False;
   end Total_Drivers;

   function Driver_Name (Index : in Natural) return String is
      function SDL_Get_Video_Driver (I : in C.int) return C.Strings.chars_ptr with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_GetVideoDriver";

      C_Str : C.Strings.chars_Ptr := SDL_Get_Video_Driver (C.int (Index));
   begin
      return C.Strings.Value (C_Str);
   end Driver_Name;

   function Current_Driver_Name return String is
      function SDL_Get_Current_Video_Driver return C.Strings.chars_ptr with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_GetCurrentVideoDriver";

      C_Str : C.Strings.chars_ptr := SDL_Get_Current_Video_Driver;
   begin
      return C.Strings.Value (C_Str);
   end Current_Driver_Name;

   function Total_Displays (Total : out Positive) return Boolean is
      function SDL_Get_Num_Video_Displays return C.int with
        Import        => True,
        Convention    => C,
        External_Name => "SDL_GetNumVideoDisplays";

      Num : constant C.int := SDL_Get_Num_Video_Displays;
   begin
      if Num < 0 then
         Total := Positive'Last;

         return True;
      end if;

      Total := Positive (Total);

      return False;
   end Total_Displays;
end SDL.Video;
