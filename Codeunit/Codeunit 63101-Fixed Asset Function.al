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
            FADepBook.SetRange("FA No.");
            if FADepBook.FindSet() then
                repeat
                    FADepBook.Validate("No. of Depreciation Years", FASubClass."Umur Ekonomis");
                    FADepBook.Modify();
                until FADepBook.Next() = 0;
        end;

    end;


    var
        myInt: Integer;
}