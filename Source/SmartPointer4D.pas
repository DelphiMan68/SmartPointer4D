{******************************************************************************
  SmartPointer4D
  Created by: Shaahin Ashayeri
  GitHub: http://github.com/delphiMan68/SmartPointer4D
******************************************************************************}

unit SmartPointer4D;

{$IFDEF FPC}
  {$MODE DELPHI}
  {$H+}
{$ENDIF}

interface

type
  TSmartPointerOwner = class(TInterfacedObject)
  private
    FValue: TObject;
  public
    constructor Create(AValue: TObject);
    destructor Destroy; override;
    function GetValue: TObject;
  end;

  { Shared record-based API for Delphi and Free Pascal.
    The interface field provides automatic shared ownership. }
  TSmart<T: class, constructor> = record
  private
    FOwner: IInterface;
    FValue: T;
    function GetObj: T;
    function GetIsEmpty: Boolean;
  public
    class function New: TSmart<T>; static;
    { Short aliases intended to make Delphi call sites more concise. }
    class function Create: TSmart<T>; static;
    class function From(AValue: T): TSmart<T>; static;
    class function Own(AValue: T): TSmart<T>; static;
    { Optional early release. Normally, let the record leave scope instead. }
    procedure Clear;
    { The same object-access property is available in Delphi and FPC. }
    property Obj: T read GetObj;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

implementation

uses
  SysUtils;

constructor TSmartPointerOwner.Create(AValue: TObject);
begin
  inherited Create;
  FValue := AValue;
end;

destructor TSmartPointerOwner.Destroy;
begin
  FValue.Free;
  inherited Destroy;
end;

function TSmartPointerOwner.GetValue: TObject;
begin
  Result := FValue;
end;

class function TSmart<T>.New: TSmart<T>;
begin
  Result := From(T.Create);
end;

class function TSmart<T>.Create: TSmart<T>;
begin
  Result := New;
end;

class function TSmart<T>.From(AValue: T): TSmart<T>;
begin
  if AValue = nil then
    raise Exception.Create('SmartPointer4D: cannot own a nil object');

  Result.FValue := AValue;
  Result.FOwner := TSmartPointerOwner.Create(AValue);
end;

class function TSmart<T>.Own(AValue: T): TSmart<T>;
begin
  Result := From(AValue);
end;

procedure TSmart<T>.Clear;
begin
  { Clear only releases this record's ownership reference early.
    Other copies keep the object alive. It is not needed for normal cleanup. }
  FValue := nil;
  FOwner := nil;
end;

function TSmart<T>.GetObj: T;
begin
  Result := FValue;
end;

function TSmart<T>.GetIsEmpty: Boolean;
begin
  Result := FValue = nil;
end;

end.
