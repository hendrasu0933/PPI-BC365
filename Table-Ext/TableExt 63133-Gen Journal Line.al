tableextension 63133 "Gen Journal Line-Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(63101; "First User Id"; Text[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }

    var
        myInt: Integer;

}