page 63102 "List Budget All"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "G/L Budget Name";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Committed Budget"; rec."Committed Budget")
                {
                    ApplicationArea = all;
                }
                field("Default Budget"; rec."Default Budget")
                {
                    ApplicationArea = all;
                }
                field("Budget Dimension 1 Code"; rec."Budget Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Budget Dimension 2 Code"; rec."Budget Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Budget Dimension 3 Code"; rec."Budget Dimension 3 Code")
                {
                    ApplicationArea = all;
                }
                field("Budget Dimension 4 Code"; rec."Budget Dimension 4 Code")
                {
                    ApplicationArea = all;
                }
                field(Blocked; rec.Blocked)
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
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}