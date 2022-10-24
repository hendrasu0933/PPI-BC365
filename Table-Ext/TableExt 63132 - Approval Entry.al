tableextension 63132 ApprovalENtry extends "Approval Entry"
{
    fields
    {
        // Add changes to table fields here
        field(63000; "First User Id"; Text[50])
        {
            TableRelation = User."User Name";
        }
    }

    var
        myInt: Integer;

}