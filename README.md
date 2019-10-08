# CSVUtils
Utils for CSV writing
# Example usage
```delphi
var
  writer: ICSVWriter;
begin
  writer:=TCSVWriter.Create;
  writer.Fields(['PLU','Name','Supplier'])
    .Field('Quantity')
    .Field('Price')
    //.QuoteStr(True)
    //.Delimiter('|')
    .AddRow
    .Value('Name','Zkouska 110')
    .Value('PLU',110)
    .Value('Supplier','AnyFirm')
    .Value('Price',123.50)
    .AddRow
    .Value('PLU',100)
    .Value('Name','Zkouska 100')
    .Value('Supplier','AnyFirm')
    .Value('Quantity',100.23)
    .AddRow
    .Value('Name','Zkouska 200')
    .Value('PLU',200)
    .Value('Supplier','AnyFirm')
    .AddRow
    .Value('PLU',300)
    .Value('Supplier','AnyFirm')
    .SaveToFile('Test.CSV');
end;
```
# Dependency
[Spring4d](http://https://bitbucket.org/sglienke/spring4d)
