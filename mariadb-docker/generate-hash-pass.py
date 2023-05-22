import hashlib, getpass

def mysql_hash(pw: str) -> str:
    pw = pw.encode()
    mid = hashlib.sha1(pw).digest()
    inner = hashlib.sha1(mid).hexdigest()
    return '*' + inner.upper()

assert mysql_hash('mariadb') == '*54958E764CE10E50764C2EECBB71D01F08549980'

print(mysql_hash(getpass.getpass('Password: ')))
