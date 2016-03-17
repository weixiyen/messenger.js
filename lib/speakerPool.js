var speaker = require('./speaker'),
    Pool = require('generic-pool').Pool;

function SpeakerPool(addresses, poolSettings) {
    poolSettings = poolSettings || {};
    poolSettings.create = function create(callback) {
        var Client = new speaker(addresses, function (a) {
            callback(null, Client);
        });
    }

    poolSettings.destroy = function destroy(client) {
        client.destroy();
    }

    this.pool = Pool(poolSettings);
}

SpeakerPool.prototype.request = function (subject, data, callback) {
    var self = this;
    this.pool.acquire(function (err, client) {
        client.request(subject, data, function () {
            callback && callback.apply(this, arguments);
            self.pool.release(client);
        });
    });
};

SpeakerPool.prototype.shout = function (subject, data) {
    var self = this;
    this.pool.acquire(function (err, client) {
        client.shout(subject, data);
        self.pool.release(client);
    });
};

module.exports = SpeakerPool;