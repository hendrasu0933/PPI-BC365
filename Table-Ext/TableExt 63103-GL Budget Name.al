tableextension 63103 "GL Budget name-Ext" extends "G/L Budget Name"
{
    fields
    {
        // Add changes to table fields here
        field(63101; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval";
            Editable = false;
        }
    }

    var
        myInt: Integer;
}