pageextension 63104 "GL Budget Name-Ext" extends "G/L Budget Names"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field(Status; rec.Status)
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