program SmartPointer4DFreePascalDemo;

{$APPTYPE CONSOLE}

{$MODE DELPHI}
{$H+}

uses
  SysUtils,
  SmartPointer4D;

type
  TUser = class
  public
    Name: string;
    constructor Create;
    destructor Destroy; override;
    procedure Save;
  end;

constructor TUser.Create;
begin
  inherited Create;
  Writeln('  [TUser] Created');
end;

destructor TUser.Destroy;
begin
  Writeln('  [TUser] Destroyed automatically');
  inherited Destroy;
end;

procedure TUser.Save;
begin
  Writeln('  [TUser] Saving user: ', Name);
end;

procedure RunSmartPointerDemo;
var
  User: TSmart<TUser>;
  SharedUser: TSmart<TUser>;
begin
  Writeln('  Entering RunSmartPointerDemo');

  // New creates the object and gives the smart pointer its ownership.
  // There is no need to call Free when using the smart pointer.
  User := TSmart<TUser>.New;
  User.Obj.Name := 'Free Pascal';
  User.Obj.Save;

  // Copying a smart pointer shares ownership; it does not create a
  // second TUser instance. The object stays alive while either copy exists.
  SharedUser := User;
  SharedUser.Obj.Name := 'Shared by two smart pointers';
  SharedUser.Obj.Save;

  // No Clear call is needed here. When this routine exits, both local
  // smart-pointer records are finalized automatically. The shared owner
  // is released, and TUser.Destroy runs when the last reference disappears.
  Writeln('  Leaving RunSmartPointerDemo; local smart pointers go out of scope');
end;

begin
  Writeln('SmartPointer4D - Free Pascal demo');
  Writeln('Before the routine:');

  RunSmartPointerDemo;

  // TUser.Destroy should already have been called before this line.
  Writeln('Back in the main block: the managed object has been released.');
  Readln;
end.
