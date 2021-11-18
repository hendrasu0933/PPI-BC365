page 63108 "Customer Read Only"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Customer;
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
                field(Name; rec.Name)
                {
                    ApplicationArea = All;

                }
                field(Address; rec.Address)
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; rec."E-Mail")
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