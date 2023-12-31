exports.handler = async function (event, context) {
    console.log("This is a sample Azure function provided by Techie-In-You");
    console.log("EVENT: \n" + JSON.stringify(event, null, 2));
    return context.logStreamName;
  };