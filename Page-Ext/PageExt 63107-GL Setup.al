pageextension 63107 "GL Setup-Ext" extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("LCY Code")
        {
            field("Approval Type"; rec."Approval Type")
            {
                ApplicationArea = all;
            }
            field("Direktur Utama"; Rec."Direktur Utama")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}