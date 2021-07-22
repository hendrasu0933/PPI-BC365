table 63104 "Item Front End"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Kode; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                //    if StrLen(Kode) <= 20 then
                //        "Item No. BC" := Kode
                //    else
                //        "Item No. BC" := CopyStr(Kode, 1, 20);
            end;
        }
        field(2; Deskripsi; Text[100])
        { }
        field(4; "Unit of Measure"; Code[20])
        { }
        field(5; "Item No. BC"; Code[20])
        {
            TableRelation = Item;
        }
        field(6; "Config Template BC"; Code[10])
        {
            TableRelation = "Config. Template Header" where("Table ID" = const(27));
        }
    }

    keys
    {
        key(Key1; Kode)
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