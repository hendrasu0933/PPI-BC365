pageextension 63109 FAPostingGroups extends "FA Posting Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field(Keterangan; GetKeterangan())
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here

    }
    local procedure GetKeterangan(): Text
    var
        FASubClass: Record "FA Subclass";
    begin
        FASubClass.SetRange("Default FA Posting Group", Rec.Code);
        if FASubClass.FindFirst() and (FASubClass.Count = 1) then
            exit(FASubClass.Name);
    end;

    var
        myInt: Integer;
}