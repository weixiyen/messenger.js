var expect = require('chai').expect,
    messenger = require('../lib/messenger.js');


describe('server', function () {
    var server, client;
    it('Should create server', function () {
        server = messenger.createListener(8000);
        expect(server).to.be.ok;
    })

    it('Should create client', function () {
        client = messenger.createSpeakerPool(8000, {
            max: 1,
            min: 1,
            idleTimeoutMillis: 30000
        });
        expect(client).to.be.ok;
    })

    it('Should communicate between client and server', function (done) {
        server.on('give it to me', function (message, data) {
            expect(data).to.deep.equal({ hello: 'world' });
            message.reply({ 'you': 'got it' });
       });

        setInterval(function () {
            client.request('give it to me', { hello: 'world' }, function (data) {
                expect(data).to.deep.equal({ 'you': 'got it' });
                done();
            });
        }, 100);
    });
});