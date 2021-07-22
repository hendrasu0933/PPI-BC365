page 63106 "Journal Line Document"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Journal Line Document";

    layout
    {
        area(Content)
        {
            repeater(Journal)
            {
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Journal Batch"; rec."Journal Batch")
                {
                    ApplicationArea = All;

                }
                field("Journal Template"; rec."Journal Template")
                {
                    ApplicationArea = all;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Status; rec.Status)
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

            }
        }
    }

    var
        myInt: Integer;
}