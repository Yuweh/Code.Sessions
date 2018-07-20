

    @objc fileprivate func syncCharts(srcChart: ChartHelper, dstChart: ChartHelper) {
        
        if dstChart.isHidden {
            return
        }
        
        let srcMatrix = srcChart.viewPortHandler.touchMatrix
        let dstMatrix = dstChart.viewPortHandler.touchMatrix
        
        let newMatrix = CGAffineTransform.init(a: srcMatrix.a,
                                               b: dstMatrix.b,
                                               c: srcMatrix.c,
                                               d: dstMatrix.d,
                                               tx: srcMatrix.tx,
                                               ty: dstMatrix.ty)
        
        let _ = dstChart.viewPortHandler.refresh(newMatrix: newMatrix, chart: dstChart, invalidate: true)
    }

// MARK: ChartViewDelegate
extension InfoViewController: ChartViewDelegate {
    
    fileprivate func chartViewChecker(_ chartView: ChartViewBase) {
        if (chartView == self.mChartTop) {
            syncCharts(srcChart: self.mChartTop, dstChart: self.mChartBottom)
        } else if (chartView == self.mChartBottom) {
            syncCharts(srcChart: self.mChartBottom, dstChart: self.mChartTop)
        } else if (chartView == self.mChartTHI) {
            syncCharts(srcChart: self.mChartTHI, dstChart: self.mChartTop)
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartViewChecker(chartView)
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartViewChecker(chartView)
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        chartViewChecker(chartView)
    }
    
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        chartViewChecker(chartView)
    }
}
