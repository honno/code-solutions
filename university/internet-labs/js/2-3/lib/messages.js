const sanitizeHTML = require('sanitize-html');

module.exports = function(url,callback){
    const mongoose = require('mongoose');
    mongoose.connect(url,callback);

    const Message = mongoose.model(
        'messages',
        {
            username: {
                type: String,
                required: true
            },
            text: {
                type: String,
                required: true
            }
        }
    );

    return {
        create:function(newMessage,callback){
            try {
                var message = new Message(newMessage);
            } catch (err) {
                callback(err);
            }

            message.username = sanitizeHTML(message.username);
            message.text = sanitizeHTML(message.text);

            message.save(callback);
        },
        read:function(id,callback){
            Message.findById(id, callback);
        },
        readUsername:function(username,callback){
            Message.find({ username: username }, callback);
        },
        readAll:function(callback){
            Message.find({}, callback);
        },
        update:function(id,updatedMessage,callback){
            Message.findByIdAndUpdate(id, updatedMessage, callback);
        },
        delete:function(id,callback){
            Message.findByIdAndRemove(id, callback);
        },
        deleteAll:function(callback){
            Message.remove({},callback);
        },
        disconnect:function(){
            mongoose.disconnect();
        }
    };
};
