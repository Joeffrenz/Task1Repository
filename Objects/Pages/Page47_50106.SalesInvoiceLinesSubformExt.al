pageextension 50106 SalesInvoiceSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            //additional field for Item Attributes
            field(Attributes; Rec.Attributes)
            {
                ApplicationArea = All;
                Caption = 'Item Attributes';
            }
        }
    }
}