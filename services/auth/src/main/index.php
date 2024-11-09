<?php

declare(strict_types=1);

namespace kuaukutsu\poc\service\info\main;

use Leaf\App;
use LogicException;

require dirname(__DIR__, 2) . '/vendor/autoload.php';

$app = new App();
$app::set404(static function () use ($app)  {
    $app->response()->json(
        [
            'message' => '404 Not Found',
        ],
        404
    );
});

$app::get('/', static function () use ($app) {
    $app->response()->json(
        [
            'message' => 'Service Auth',
        ]
    );
});

$app::post('/login', static function () use ($app) {
    $exp = strtotime('+1 hour');
    $params = $app->request()->postData();
    if (isset($params['username'], $params['password']) === false) {
        throw new LogicException("username and password are required.");
    }

    $uid = md5($params['username']);
    $app->response()->json(
        [
            'access_token' => [
                'aud' => 'http://api.localhost',
                'iss' => 'http://auth.localhost',
                'sub' => $uid,
                'jti' => bin2hex(random_bytes(32)),
                'roles' => ['user', 'root'],
                'exp' => $exp,
            ],
            'refresh_token' => [
                'aud' => 'http://api.localhost',
                'iss' => 'http://auth.localhost',
                'sub' => $uid,
                'jti' => bin2hex(random_bytes(32)),
                'exp' => $exp,
            ],
            'exp' => $exp,
        ]
    );
});

$app::run();
