codeunit 63101 "Fixed Asset Function"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(objectType::table, database::"Fixed Asset", 'OnAfterValidateEvent', 'FA Subclass Code', true, true)]
    local procedure ValidateFASubclass(CurrFieldNo: Integer; var Rec: Record "Fixed Asset"; var xRec: Record "Fixed Asset")
    var
        FASubClass: Record "FA Subclass";
        FADepBook: Record "FA Depreciation Book";
    begin
        if FASubClass.Get(Rec."FA Subclass Code") then begin
            FADepBook.SetRange("FA No.", Rec."No.");
            if FADepBook.FindSet() then
                repeat
                    if (FADepBook."Depreciation Starting Date" <> 0D) or (FADepBook."Depreciation Ending Date" <> 0D) then begin
                        FADepBook.Validate("No. of Depreciation Years", FASubClass."Umur Ekonomis");
                        FADepBook.Modify();
                    end;
                until FADepBook.Next() = 0;
        end;
    end;

    [EventSubscriber(objectType::table, database::"FA Depreciation Book", 'OnAfterValidateEvent', 'Depreciation Starting Date', true, true)]
    local procedure ValidateStartDate(CurrFieldNo: Integer; var Rec: Record "FA Depreciation Book"; var xRec: Record "FA Depreciation Book")
    var
        FASubClass: Record "FA Subclass";
        FA: Record "Fixed Asset";
    begin
        if FA.Get(Rec."FA No.") and FASubClass.Get(FA."FA Subclass Code") and (FASubClass."Umur Ekonomis" > 0) and
        (Rec."No. of Depreciation Years" = 0) and (Rec."Depreciation Ending Date" = 0D) then begin
            Rec.Validate("No. of Depreciation Years", FASubClass."Umur Ekonomis");
            //    Rec.Modify();
        end;
    end;

    [EventSubscriber(objectType::table, database::"FA Depreciation Book", 'OnBeforeValidateEvent', 'Depreciation Ending Date', true, true)]
    local procedure ValidateEndDate(CurrFieldNo: Integer; var Rec: Record "FA Depreciation Book"; var xRec: Record "FA Depreciation Book")
    var
        FASubClass: Record "FA Subclass";
        FA: Record "Fixed Asset";
    begin
        if FA.Get(Rec."FA No.") and FASubClass.Get(FA."FA Subclass Code") and (FASubClass."Umur Ekonomis" > 0) and
        (Rec."No. of Depreciation Years" = 0) and (Rec."Depreciation Starting Date" = 0D) then begin
            Rec.Validate("No. of Depreciation Years", FASubClass."Umur Ekonomis");
            //    Rec.Modify();
        end;
    end;

    var
        myInt: Integer;
}