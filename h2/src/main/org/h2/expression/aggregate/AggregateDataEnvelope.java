/*
 * Copyright 2004-2025 H2 Group. Multiple-Licensed under the MPL 2.0,
 * and the EPL 1.0 (https://h2database.com/html/license.html).
 * Initial Developer: H2 Group
 */
package org.h2.expression.aggregate;

import org.h2.engine.SessionLocal;
import org.h2.expression.Expression;
import org.h2.expression.ExpressionColumn;
import org.h2.index.Index;
import org.h2.mvstore.db.MVSpatialIndex;
import org.h2.table.Column;
import org.h2.table.TableFilter;
import org.h2.util.geometry.GeometryUtils;
import org.h2.value.Value;
import org.h2.value.ValueGeometry;
import org.h2.value.ValueNull;

/**
 * Data stored while calculating an aggregate.
 */
final class AggregateDataEnvelope extends AggregateData {

    private double[] envelope;

    /**
     * Get the index (if any) for the column specified in the geometry
     * aggregate.
     *
     * @param on
     *            the expression (usually a column expression)
     * @return the index, or null
     */
    static Index getGeometryColumnIndex(Expression on) {
        if (on instanceof ExpressionColumn) {
            ExpressionColumn col = (ExpressionColumn) on;
            Column column = col.getColumn();
            if (column.getType().getValueType() == Value.GEOMETRY) {
                TableFilter filter = col.getTableFilter();
                if (filter != null) {
                    for (Index index : filter.getTable().getIndexes()) {
                        if (index instanceof MVSpatialIndex && index.isFirstColumn(column)) {
                            return index;
                        }
                    }
                }
            }
        }
        return null;
    }

    @Override
    void add(SessionLocal session, Value v) {
        if (v == ValueNull.INSTANCE) {
            return;
        }
        envelope = GeometryUtils.union(envelope, v.convertToGeometry(null).getEnvelopeNoCopy());
    }

    @Override
    Value getValue(SessionLocal session) {
        return ValueGeometry.fromEnvelope(envelope);
    }

}
