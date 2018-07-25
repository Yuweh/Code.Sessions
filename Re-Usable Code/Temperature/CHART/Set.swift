private void setTypeThiYAxisProperties(YAxis yAxis, float maxY, float minY) {
        yAxis.setLabelCount(3);

        float range = maxY - minY;
        float margin = (30 - range) / 2;

        if (margin < 5) {
            margin = 5;
        }

        yAxis.setAxisMaximum(maxY + margin);
        yAxis.setAxisMinimum(minY - margin);
    }
