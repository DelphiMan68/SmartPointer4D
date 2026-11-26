program SmartPointer4DDelphiDemo;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  SmartPointer4D in '..\..\Source\SmartPointer4D.pas';

type
  TUser = class
  private
    FName: string;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;
    procedure Save;

    property Name: string read FName write FName;
  end;

constructor TUser.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  Writeln('  [TUser] Created: ', FName);
end;

destructor TUser.Destroy;
begin
  Writeln('  [TUser] Destroyed: ', FName);
  inherited Destroy;
end;

procedure TUser.Save;
begin
  Writeln('  [TUser] Saving user: ', FName);
end;

{ Demonstrates concise creation, shared ownership, and automatic release.
  The object is destroyed when the final smart-pointer copy leaves scope. }
procedure DemonstrateSharedOwnership;
var
  User, SharedUser: TSmart<TUser>;
begin
  Writeln('Entering DemonstrateSharedOwnership');

  { Create is the concise alias for New. }
  User := TSmart<TUser>.Create;
  User.Obj.Name := 'Shaahin';
  User.Obj.Save;

  { Assignment shares ownership of the same TUser instance. }
  SharedUser := User;
  SharedUser.Obj.Save;

  { No Clear, Free, or nil assignment is required.
    Both local smart pointers leave scope when this routine returns. }
  Writeln('Leaving DemonstrateSharedOwnership');
end;

{ Demonstrates taking ownership of an object created elsewhere.
  Own is the concise alias for From; do not Free the instance afterward. }
procedure DemonstrateAdoptingExistingObject;
var
  User: TSmart<TUser>;
begin
  Writeln('Entering DemonstrateAdoptingExistingObject');

  User := TSmart<TUser>.Own(TUser.Create('Adopted object'));
  User.Obj.Save;

  { The smart pointer releases the object automatically at scope exit. }
  Writeln('Leaving DemonstrateAdoptingExistingObject');
end;

begin
  Writeln('SmartPointer4D - Delphi demo');
  Writeln;

  DemonstrateSharedOwnership;
  Writeln('Back in main: shared object should now be destroyed.');
  Writeln;

  DemonstrateAdoptingExistingObject;
  Writeln('Back in main: adopted object should now be destroyed.');

  Readln;
end.
