<?php
function db(): mysqli {
  static $conn;
  if ($conn instanceof mysqli) return $conn;
  $url = getenv('DATABASE_URL');
  if ($url) {
    $parts = parse_url($url);
    $host = $parts['host'] ?? '127.0.0.1'; $user = urldecode($parts['user'] ?? 'root');
    $pass = urldecode($parts['pass'] ?? ''); $port = (int)($parts['port'] ?? 3306); $name = ltrim($parts['path'] ?? '/tritrack_db_prc','/');
  } else { $host=getenv('DB_HOST') ?: '127.0.0.1'; $user=getenv('DB_USER') ?: 'root'; $pass=getenv('DB_PASSWORD') ?: ''; $port=(int)(getenv('DB_PORT') ?: 3306); $name=getenv('DB_NAME') ?: 'tritrack_db_prc'; }
  mysqli_report(MYSQLI_REPORT_OFF); $conn = @new mysqli($host,$user,$pass,$name,$port);
  if ($conn->connect_errno) throw new Exception('MariaDB connection failed: '.$conn->connect_error);
  $conn->set_charset('utf8mb4'); return $conn;
}
function json_response(array $data,int $status=200): never { http_response_code($status); header('Content-Type: application/json'); echo json_encode($data); exit; }
function input(): array { return json_decode(file_get_contents('php://input'), true) ?: $_POST; }
function session_user(): ?array { return $_SESSION['tritrack_user'] ?? null; }
function hash_password(string $p): string { return hash('sha256',$p); }
