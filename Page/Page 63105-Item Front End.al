page 63105 "Item Front End"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Item Front End";

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
                field(Deskripsi; rec.Deskripsi)
                {
                    ApplicationArea = All;

                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Item No. BC"; rec."Item No. BC")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    InterfaceFunc: Codeunit "Interface Function";
                begin
                    InterfaceFunc.CreateItem(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}