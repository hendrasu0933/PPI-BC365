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
<<<<<<< HEAD
            field("Activate Checking Budget"; rec."Activate Checking Budget")
=======
            field("Direktur Utama"; Rec."Direktur Utama")
>>>>>>> e1f06421d0d31a64ea026f3ea9d73d3880a07017
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