
    @objc fileprivate func syncCharts(srcChart: ChartHelper, dstChart: ChartHelper, newChart: ChartHelper) {
        
        if dstChart.isHidden {
            return
        }
        
        let srcMatrix = srcChart.viewPortHandler.touchMatrix
        let dstMatrix = dstChart.viewPortHandler.touchMatrix
        let addOnMatrix = newChart.viewPortHandler.touchMatrix
        
        let newMatrix = CGAffineTransform.init(a: srcMatrix.a,
                                               b: dstMatrix.b,
                                               c: srcMatrix.c,
                                               d: dstMatrix.d,
                                               tx: srcMatrix.tx,
                                               ty: dstMatrix.ty)
        
        let addUpMatrix = CGAffineTransform.init(a: newMatrix.a,
                                                 b: addOnMatrix.b,
                                                 c: newMatrix.c,
                                                 d: addOnMatrix.d,
                                                 tx: newMatrix.tx,
                                                 ty: addOnMatrix.ty)
        
        let _ = dstChart.viewPortHandler.refresh(newMatrix: newMatrix, chart: dstChart, invalidate: true)
    
        let _ = newChart.viewPortHandler.refresh(newMatrix: addUpMatrix, chart: newChart, invalidate: true)
    }
    
    
      fileprivate func chartViewChecker(_ chartView: ChartViewBase) {
        if (chartView == self.topChartView) {
            syncCharts(srcChart: self.topChartView, dstChart: self.bottomChartView, newChart: self.mChartTHI)
        } else if (chartView == self.bottomChartView) {
            syncCharts(srcChart: self.bottomChartView, dstChart: self.topChartView, newChart: self.mChartTHI)
        } else if (chartView == self.mChartTHI) {
            syncCharts(srcChart: self.mChartTHI, dstChart: self.topChartView, newChart: self.bottomChartView)
        }
    }

