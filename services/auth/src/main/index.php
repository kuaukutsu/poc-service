<?php

declare(strict_types=1);

namespace kuaukutsu\poc\service\info\main;

use Leaf\App;

require dirname(__DIR__, 2) . '/vendor/autoload.php';

$app = new App();

$app::get('/', static function () use ($app) {
    $app->response()->json(
        [
            'message' => 'Service Auth',
        ]
    );
});

$app::post('/login', static function () use ($app) {
    $exp = strtotime('+1 hour');
    $app->response()->json(
        [
            'access_token' => [
                'aud' => 'http://api.localhost',
                'iss' => 'http://auth.localhost',
                'sub' => '123',
                'jti' => bin2hex(random_bytes(32)),
                'roles' => ['user', 'root'],
                'exp' => $exp,
            ],
            'refresh_token' => [
                'aud' => 'http://api.localhost',
                'iss' => 'http://auth.localhost',
                'sub' => '123',
                'jti' => bin2hex(random_bytes(32)),
                'exp' => $exp,
            ],
            'exp' => $exp,
        ]
    );
});

$app::run();
