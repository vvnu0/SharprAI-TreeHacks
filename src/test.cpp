#include "test.h"
#include <QMessageBox>

TestWidget::TestWidget(QWidget* parent) : QDockWidget(parent) {
    QWidget* widget = new QWidget(this);
    layout = new QVBoxLayout;

    startStreamingButton = new QPushButton("Start Streaming", this);
    stopStreamingButton = new QPushButton("Stop Streaming", this);
    stopStreamingButton->setEnabled(false); // Disable stop button initially

    layout->addWidget(startStreamingButton);
    layout->addWidget(stopStreamingButton);
    widget->setLayout(layout);

    setWidget(widget);

    connect(startStreamingButton, &QPushButton::clicked, this, &TestWidget::onStartStreamingClicked);
    connect(stopStreamingButton, &QPushButton::clicked, this, &TestWidget::onStopStreamingClicked);
}

void TestWidget::onStartStreamingClicked() {
    // Placeholder for streaming logic
    QMessageBox::information(this, "Streaming", "Streaming started.");
    startStreamingButton->setEnabled(false);
    stopStreamingButton->setEnabled(true);
}

void TestWidget::onStopStreamingClicked() {
    // Placeholder for streaming logic
    QMessageBox::information(this, "Streaming", "Streaming stopped.");
    startStreamingButton->setEnabled(true);
    stopStreamingButton->setEnabled(false);
}