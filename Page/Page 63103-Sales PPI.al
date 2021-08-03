page 63103 "Sales PPI"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales PPI";

    layout
    {
        area(Content)
        {
            repeater(Transaction)
            {
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Customer No."; rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Payment Method"; rec."Payment Method")
                {
                    ApplicationArea = all;
                }
                field(Currency; rec.Currency)
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Unit Bisnis"; rec."Unit Bisnis")
                {
                    ApplicationArea = all;
                }
                field("Cust. No. BC"; rec."Cust. No. BC")
                {
                    ApplicationArea = all;
                }
                field("Item No. BC"; rec."Item No. BC")
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
            action("Create Sales Invoice")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    InterfaceFunc: Codeunit "Interface Function";
                begin
                    InterfaceFunc.CreateSalesInv(Rec);
                end;

            }
        }
    }

    var
        myInt: Integer;
}