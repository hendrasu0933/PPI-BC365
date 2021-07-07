tableextension 63103 "GL Budget name-Ext" extends "G/L Budget Name"
{
    fields
    {
        // Add changes to table fields here
        field(63101; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval";
            Editable = false;
            trigger OnValidate()
            begin
                if Status = Status::Released then
                    "Released by" := UserId
                else
                    "Released by" := '';
            end;
        }
        field(63102; "Committed Budget"; Boolean)
        {

        }
        field(63103; "Default Budget"; Boolean)
        {

        }
        field(63104; "Released by"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;

        }
    }

    var
        myInt: Integer;
}