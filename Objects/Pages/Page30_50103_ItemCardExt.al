pageextension 50103 "ItemCardExt" extends "Item Card"
{

    trigger OnAfterGetCurrRecord()
    begin
        //Pass the Item No. to Item factbox extension
        CurrPage.ItemAttributesFactbox.Page.GetItemNo(Rec."No.");
    end;

    trigger OnOpenPage()
    begin
        CurrPage.ItemAttributesFactbox.Page.GetItemNo(Rec."No.");
    end;
}