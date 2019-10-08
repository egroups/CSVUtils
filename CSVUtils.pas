unit CSVUtils;

interface
uses
  System.Rtti, Spring.Collections;

type
  ICSVWriter=Interface(IInvokable)
    ['{F78811E7-21F2-4C20-935D-1157C8B817D7}']
    function AddRow: ICSVWriter;
    function Delimiter(const pDelimiter: Char): ICSVWriter;
    function Field(const pFieldName: string): ICSVWriter;
    function Fields(const pFieldNames: array of string): ICSVWriter;
    function QuoteStr(const pEnable: Boolean): ICSVWriter;
    procedure SaveToFile(const pFileName: string);
    function Value(const pFieldName: string; const pValue: TValue): ICSVWriter;

  End;

  TCSVWriter=class(TInterfacedObject,ICSVWriter)

  private
    FCurrentLine: IDictionary<string,TValue>;
    FIntDelimiter: Char;
    FIntFields: IList<string>;
    FIntQuoteStr: Boolean;
    FLines: IList<IDictionary<string,TValue>>;
    property CurrentLine: IDictionary<string,TValue> read FCurrentLine write
        FCurrentLine;
    property IntDelimiter: Char read FIntDelimiter write FIntDelimiter;
    property IntFields: IList<string> read FIntFields write FIntFields;
    property IntQuoteStr: Boolean read FIntQuoteStr write FIntQuoteStr;
    property Lines: IList<IDictionary<string,TValue>> read FLines write FLines;
  public
    constructor Create;
    function AddRow: ICSVWriter;
    function Delimiter(const pDelimiter: Char): ICSVWriter;
    function Field(const pFieldName: string): ICSVWriter;
    function Fields(const pFieldNames: array of string): ICSVWriter;
    function QuoteStr(const pEnable: Boolean): ICSVWriter;
    procedure SaveToFile(const pFileName: string);
    function Value(const pFieldName: string; const pValue: TValue): ICSVWriter;
  end;

implementation

uses
  System.Classes, Spring, System.SysUtils;

constructor TCSVWriter.Create;
begin
  inherited;
  FIntDelimiter:=';';
  FIntQuoteStr:=False;
  FIntFields:=TCollections.CreateList<string>;
  FLines:=TCollections.CreateList<IDictionary<string,TValue>>;
end;

function TCSVWriter.AddRow: ICSVWriter;
begin
  Result:=self;
  CurrentLine:=TCollections.CreateDictionary<string,TValue>;
  Lines.Add(CurrentLine);
end;

function TCSVWriter.Delimiter(const pDelimiter: Char): ICSVWriter;
begin
  Result:=self;
  FIntDelimiter:=pDelimiter;
end;

function TCSVWriter.Field(const pFieldName: string): ICSVWriter;
begin
  Result:=self;
  FIntFields.Add(pFieldName);
end;

function TCSVWriter.Fields(const pFieldNames: array of string): ICSVWriter;
begin
  Result:=self;
  FIntFields.AddRange(pFieldNames);
end;

function TCSVWriter.QuoteStr(const pEnable: Boolean): ICSVWriter;
begin
  Result:=self;
  FIntQuoteStr:=pEnable;
end;

procedure TCSVWriter.SaveToFile(const pFileName: string);
var
  header: TStringList;
  sl: TStringList;
begin
  sl:=TStringList.Create;
  try
    //hlavicka
    header:=TStringList.Create;
    try
      header.Delimiter:=IntDelimiter;
      header.StrictDelimiter:=True;

      IntFields.ForEach(
        procedure(const pFieldName:string)
        begin
          header.Add(pFieldName);
        end
      );
      sl.Add(header.DelimitedText);
    finally
      header.Free;
    end;
    //polozky
    Lines.ForEach(
      procedure(const line:IDictionary<string,TValue>)
      var
        row:TStringList;
        lValue:TValue;
      begin
        row:=TStringList.Create;
        try
          row.Delimiter:=IntDelimiter;
          row.StrictDelimiter:=True;

          IntFields.ForEach(
            procedure(const pFieldName:string)
            begin
              if line.TryGetValue(pFieldName,lValue) then
                if lValue.IsString then
                begin
                  if IntQuoteStr then
                    row.Add(lValue.ToString.QuotedString('"'))
                  else
                    row.Add(lValue.ToString);
                end
                else
                    row.Add(lValue.ToString)
              else
                row.Add('');
            end
          );
          sl.Add(row.DelimitedText);
        finally
          row.Free;
        end;
      end
    );
    sl.SaveToFile(pFileName);
  finally
    sl.Free;
  end;
end;

function TCSVWriter.Value(const pFieldName: string; const pValue: TValue):
    ICSVWriter;
begin
  Result:=self;
  CurrentLine.AddOrSetValue(pFieldName,pValue);
end;

end.

