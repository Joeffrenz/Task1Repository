tableextension 50104 SalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        //additional field for item attributes in sales line
        field(50100; Attributes; Text[250])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }
}