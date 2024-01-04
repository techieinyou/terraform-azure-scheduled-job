import logging
import azure.functions as func

app = func.FunctionApp()

def main(myTimer: func.TimerRequest) -> None:
    if myTimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function executed.')