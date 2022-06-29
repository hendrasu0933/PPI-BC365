tableextension 63105 "Gen Ledger Setup-Ext" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(63101; "Approval Type"; Option)
        {
            OptionMembers = " ",Batch,Line;
        }
<<<<<<< HEAD
        field(63102; "Activate Checking Budget"; Boolean)
        { }
=======
        field(63102; "Direktur Utama"; Text[150])
        {

        }
>>>>>>> e1f06421d0d31a64ea026f3ea9d73d3880a07017
    }

    var
        myInt: Integer;
}