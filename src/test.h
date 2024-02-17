#ifndef TEST_H
#define TEST_H

#include <QDockWidget>
#include <QPushButton>
#include <QVBoxLayout>

class TestWidget : public QDockWidget {
    Q_OBJECT
public:
    TestWidget(QWidget* parent = nullptr);

private slots:
    void onStartStreamingClicked();
    void onStopStreamingClicked();

private:
    QPushButton* startStreamingButton;
    QPushButton* stopStreamingButton;
    QVBoxLayout* layout;
};

#endif // TEST_H