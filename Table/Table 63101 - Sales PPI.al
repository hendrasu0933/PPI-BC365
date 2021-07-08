table 63101 "Sales PPI"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; code[20])
        { }
        field(3; "Posting Date"; Date)
        { }
        field(4; "Item No."; Code[20])
        { }
        field(5; Quantity; Decimal)
        { }
        field(6; "Unit of Measure"; Code[10])
        { }
        field(7; "Unit Price"; Decimal)
        { }
        field(8; "Unit Bisnis"; Code[20])
        { }
        field(9; "Payment Method"; Code[20])
        { }
        field(10; Currency; Code[10])
        { }
        field(11; "Line No."; Integer)
        { }
    }

    keys
    {
        key(Key1; "Document No.")
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