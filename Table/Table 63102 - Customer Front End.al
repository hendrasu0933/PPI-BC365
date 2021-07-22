table 63102 "Customer Front End"
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
                //        "Customer No. BC" := Kode
                //    else
                //        "Customer No. BC" := CopyStr(Kode, 1, 20);
            end;
        }
        field(2; Nama; Text[100])
        { }
        field(3; Alamat; Text[100])
        { }
        field(4; Kota; Code[20])
        { }
        field(5; "Jenis Usaha"; Text[30])
        { }
        field(6; "Badan Usaha"; Text[30])
        { }
        field(7; "Jenis Identitas"; Text[30])
        { }
        field(8; "Nomor Identitas"; Text[30])
        { }
        field(9; "NPWP"; Text[30])
        { }
        field(10; "Kontak Person"; Text[100])
        { }
        field(11; "Telp 1"; Text[30])
        { }
        field(12; "Telp 2"; Text[30])
        { }
        field(13; Fax; Text[30])
        { }
        field(14; Email; Text[80])
        { }
        field(15; "Customer No. BC"; Code[20])
        {
            TableRelation = Customer;
        }
        field(16; "Config Template BC"; Code[10])
        {
            TableRelation = "Config. Template Header" where("Table ID" = const(18));
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