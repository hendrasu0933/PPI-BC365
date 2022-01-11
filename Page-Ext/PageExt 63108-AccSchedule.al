pageextension 63108 AccSchedule extends "Account Schedule Names"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Report ID"; rec."Report ID")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here

    }

    var
        myInt: Integer;
}