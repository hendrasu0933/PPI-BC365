table 63101 "Sales PPI"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; code[20])
        {
            trigger OnValidate()
            var
                CustFront: Record "Customer Front End";
            begin
                if ("Customer No." <> '') and CustFront.Get("Customer No.") then
                    "Cust. No. BC" := CustFront."Customer No. BC";
            end;
        }
        field(3; "Posting Date"; Date)
        { }
        field(4; "Item No."; Code[20])
        {
            trigger OnValidate()
            var
                ItemFront: Record "Item Front End";
            begin
                if ("Item No." <> '') and ItemFront.Get("Item No.") then
                    "Item No. BC" := ItemFront."Item No. BC";
            end;
        }
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
        field(12; "Cust. No. BC"; Code[20])
        {
            TableRelation = Customer;

        }
        field(13; "Item No. BC"; Code[20])
        {
            TableRelation = Item;
        }
        field(14; Processed; Boolean)
        { }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
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