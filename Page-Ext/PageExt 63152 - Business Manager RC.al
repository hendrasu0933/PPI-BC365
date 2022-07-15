pageextension 63152 BusinessManagerRC extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
        addafter(ApprovalsActivities)
        {
            part(Finance; "Released Journal")
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