tableextension 63105 "Gen Ledger Setup-Ext" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(63101; "Approval Type"; Option)
        {
            OptionMembers = " ",Batch,Line;
        }
        field(63103; "Activate Checking Budget"; Boolean)
        { }
        field(63102; "Direktur Utama"; Text[150])
        {

        }
    }

    var
        myInt: Integer;
}