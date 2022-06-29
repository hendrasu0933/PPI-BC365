tableextension 63131 TblExtSalesInvLine extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
    }

    var
        myInt: Integer;

    procedure ShowAccountNo(): Text
    var
        GeneralPostingSetup: Record "General Posting Setup";
        Show: Text;
    begin
        Show := '-';
        GeneralPostingSetup.Reset();
        GeneralPostingSetup.SetRange("Gen. Bus. Posting Group", Rec."Gen. Bus. Posting Group");
        GeneralPostingSetup.SetRange("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
        if GeneralPostingSetup.FindFirst() then
            Show := GeneralPostingSetup."Sales Account";

        if rec.Type = Rec.Type::"G/L Account" then
            Show := Rec."No.";
        exit(Show);

    end;
}