table 63103 "Journal Line Document"
{
    LookupPageId = "Journal Line Document";

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Journal Template"; code[10])
        { }
        field(3; "Journal Batch"; Code[10])
        { }
        field(4; "Amount"; Decimal)
        { }

        field(5; Balance; Boolean)
        { }
        field(6; Status; Option)
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
        field(7; "Released by"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;

        }
        field(8; "No. of Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Gen. Journal Line" where("Journal Batch Name" = field("Journal Batch"), "Journal Template Name" = field("Journal Template"), "Document No." = field("Document No.")));
        }
    }

    keys
    {
        key(Key1; "Journal Template", "Journal Batch", "Document No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}