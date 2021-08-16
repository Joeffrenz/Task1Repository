pageextension 50102 "ItemAttributeFactboxExt" extends "Item Attributes Factbox"
{
    trigger OnOpenPage()
    begin
        //This will load the multiple attributes in Item Factbox.
        ShowValues();
    end;

    trigger OnAfterGetCurrRecord();
    begin
        ShowValues();
    end;

    var
        ItemAttrCode: Code[20];

    procedure GetItemNo(ItemNo: Code[20])
    begin
        ItemAttrCode := ItemNo;
    end;

    local procedure ShowValues()
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
    begin
        with ItemAttributeValueMapping do begin
            Reset();
            SetRange("No.", ItemAttrCode);
            if FindFirst() then
                repeat
                    ItemAttribute.get("Item Attribute ID");
                    if ItemAttribute.Type = ItemAttribute.Type::Option then begin
                        Rec.SetRange("Attribute ID", ItemAttribute.ID);
                        if Rec.FindFirst() then
                            if "Value Name" <> '' then begin
                                Rec.Value := "Value Name";
                                Rec.Modify();
                            end;
                        Rec.Reset();
                    end;
                until Next() = 0;
        end;
    end;
}