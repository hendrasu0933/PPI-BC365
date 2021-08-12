page 63105 "Item Read Only"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater("Master Data")
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;

                }
                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
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
            //    action("Create Item")
            //    {
            //        ApplicationArea = All;
            //        trigger OnAction()
            //        var
            //            InterfaceFunc: Codeunit "Interface Function";
            //        begin
            //            InterfaceFunc.CreateItem(Rec);
            //        end;
            //    }
        }
    }

    var
        myInt: Integer;
}