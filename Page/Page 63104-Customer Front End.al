page 63104 "Customer Front End"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Customer Front End";
    SourceTableView = where("Customer No. BC" = filter(''));
    layout
    {
        area(Content)
        {
            repeater("Master Data")
            {
                field(Kode; rec.Kode)
                {
                    ApplicationArea = all;
                }
                field(Nama; rec.Nama)
                {
                    ApplicationArea = all;
                }
                field(Alamat; Rec.Alamat)
                {
                    ApplicationArea = All;

                }
                field("Badan Usaha"; rec."Badan Usaha")
                {
                    ApplicationArea = all;
                }
                field("Jenis Usaha"; rec."Jenis Usaha")
                {
                    ApplicationArea = all;
                }
                field(Email; rec.Email)
                {
                    ApplicationArea = all;
                }
                field(Fax; rec.Fax)
                {
                    ApplicationArea = all;
                }
                field("Jenis Identitas"; rec."Jenis Identitas")
                {
                    ApplicationArea = all;
                }
                field("Kontak Person"; rec."Kontak Person")
                {
                    ApplicationArea = all;
                }
                field("Nomor Identitas"; rec."Nomor Identitas")
                {
                    ApplicationArea = all;
                }
                field(Kota; rec.Kota)
                {
                    ApplicationArea = all;
                }
                field(NPWP; rec.NPWP)
                {
                    ApplicationArea = all;
                }
                field("Telp 1"; rec."Telp 1")
                {
                    ApplicationArea = all;
                }
                field("Telp 2"; rec."Telp 2")
                {
                    ApplicationArea = all;
                }
                field("Customer No. BC"; rec."Customer No. BC")
                {
                    ApplicationArea = all;
                }
                field("Config Template BC"; rec."Config Template BC")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Customer")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    InterfaceFunc: Codeunit "Interface Function";
                begin
                    InterfaceFunc.CreateCustomer(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}