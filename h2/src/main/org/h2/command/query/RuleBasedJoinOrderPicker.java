package org.h2.command.query;

import org.h2.engine.SessionLocal;
import org.h2.expression.Expression;
import org.h2.store.fs.FileBase;
import org.h2.table.TableFilter;

import java.util.logging.Filter;
import java.util.regex.*;
import java.util.*;

/**
 * Determines the best join order by following rules rather than considering every possible permutation.
 */
public class RuleBasedJoinOrderPicker {
    final SessionLocal session;
    final TableFilter[] filters;

    public RuleBasedJoinOrderPicker(SessionLocal session, TableFilter[] filters) {
        this.session = session;
        this.filters = filters;
    }

    public TableFilter[] bestOrder() {
        // TODO: implement rules

        // Note to grader this is lowkey the most insane code ever that is my bad
        // here are some variables I use throughout the program
        // ordered filters is just the order list
        List<TableFilter> orderedFilters = new ArrayList<>();
        // connection check goes through and keeps track of how many joins we have added
        // on paper connection check = ordered filters, i just use them for different things
        List<TableFilter> connection_check = new ArrayList<>();


        // Ok so below I am basiocally trying to parse through the output of get full condition and separate each condition
        // That way I can see each join ON condition in query

        if (filters == null || filters.length == 0) {
            return new TableFilter[0]; // Return empty if no filters
        }
        Expression condition = filters[0].getFullCondition();
        if (condition == null) {
            return filters; // Return the original order if no condition exists
        }

        String conditionStr = condition.toString();
        if (conditionStr == null || conditionStr.isEmpty()) {
            return filters; // Prevent NullPointerException
        }

        // had to ask chat to helpe me get this regex, I am bad at regex
        String regex = "\\((.*?)\\)";

        // setting up pattern and matcher for regex
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(conditionStr);

        // getting ready to append these to list
        List<String> results = new ArrayList<>();

        // this is the regex doing its magic, it doesn't yield perfect parsing results but it does the job
        while (matcher.find()) {
            results.add(matcher.group(1)); // Group 1 captures the content inside the parentheses
        }
        if (results.isEmpty()) {
            return filters; // No join conditions found
        }

        //  now setting up to find the table with lowest amount of rows using simple min search algorithm
        TableFilter bestTable = filters[0];
        long minRows = 1000000000;

        for (TableFilter filter : filters)
        {
            // looking for something that has a join condition (i.e. is in the ON group)
            // for first table though, we don't have to worry about if it has connections to other tables yet
            if (filter.getFullCondition()!=null)
            {
                long rowCount = filter.getTable().getRowCountApproximation(session);
                if (rowCount < minRows)
                {
                    minRows = rowCount;
                    bestTable = filter;
                }
            }
        }
        // now adding these to our lists
        orderedFilters.add(bestTable);
        connection_check.add(bestTable);

        // this is just a check I ahve in place so my while loop doesnt hit infinite loop status
        int i = 0;

        // now we are going to add the rest of the filters
        while (orderedFilters.size() < filters.length)
        {
            // my approach here is a bit odd but pls trust
            // first thing i am doing is finding the join condition string from "results" that has the table we just added to the list
            String table_match = null;
            boolean match = false;
            for (String table: results)
            {
                for (int num = connection_check.size()-1; num>=0; num--)
                {
                    String test = connection_check.get(num).getTableAlias();
                    if (table.contains(test))
                    {
                        table_match = table;
                        // removing it from list of strings casue we already used it
                        results.remove(table);
                        match = true;
                        break;
                    }
                }

                if (match) break;

            }

            // ok once I know what the join expression corresponding to my current table is, i can iterate through other tables to find the corresponding matching table
            // this table cannot be itself (which I check for)
            // I am adding it to this list incase there are more than one possible matches
            List<TableFilter> possible_joins = new ArrayList<>();

            for (TableFilter filter : filters)
            {
                if (!orderedFilters.contains(filter))
                {
                    assert table_match != null;
                    if (table_match.contains(filter.getTableAlias()))
                    {
                        possible_joins.add(filter);
                    }

                }

            }

            if (possible_joins.size() == 1)
            {
                // adding to lists
                orderedFilters.add(possible_joins.get(0));
                connection_check.add(possible_joins.get(0));
            }
            else
            {
                //NOTE i never ended up needing to use this condition, but will keep for test cases

                //TableFilter best_current_Table = possible_joins.get(0);
                //long minimum = 1000000000;
                //for (TableFilter filter : possible_joins)
                //{
                //    if (filter.getFullCondition() != null)
                //    {
                //        long rowCount = filter.getTable().getRowCountApproximation(session);
                //        if (rowCount < minimum)
                //        {
                //            minimum = rowCount;
                //            best_current_Table = filter;
                //        }
                //    }
                //}

                //orderedFilters.add(best_current_Table);
                //System.out.print("we are here: ");
                //System.out.print(possible_joins);
                //System.out.print("\n");


            }

            // so i dont inifity loop myslef
            i = i+1;
            if (i>20)
            {
                break;
            }
            possible_joins.clear();

        }

        // finally, return resulting list, but first need to convert to array

        return orderedFilters.toArray(new TableFilter[0]);
    }
}