pageextension 63101 "FA Subclass-Ext" extends "FA Subclasses"
{
    layout
    {
        // Add changes to page layout here
        addafter("Default FA Posting Group")
        {
            field("Umur Ekonomis"; rec."Umur Ekonomis")
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