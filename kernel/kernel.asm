
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c7010113          	add	sp,sp,-912 # 80019c70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0a9050ef          	jal	800058be <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d4078793          	add	a5,a5,-704 # 80021d70 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8b090913          	add	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2b2080e7          	jalr	690(ra) # 8000630c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	352080e7          	jalr	850(ra) # 800063c0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	add	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d08080e7          	jalr	-760(ra) # 80005d92 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	add	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	81250513          	add	a0,a0,-2030 # 80008900 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	186080e7          	jalr	390(ra) # 8000627c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c6e50513          	add	a0,a0,-914 # 80021d70 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7dc48493          	add	s1,s1,2012 # 80008900 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	1de080e7          	jalr	478(ra) # 8000630c <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7c450513          	add	a0,a0,1988 # 80008900 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	27a080e7          	jalr	634(ra) # 800063c0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	79850513          	add	a0,a0,1944 # 80008900 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	250080e7          	jalr	592(ra) # 800063c0 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	add	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	sll	a2,a2,0x20
    80000186:	9201                	srl	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	add	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	add	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	add	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	sll	a3,a3,0x20
    800001aa:	9281                	srl	a3,a3,0x20
    800001ac:	0685                	add	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	add	a0,a0,1
    800001be:	0585                	add	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	add	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	add	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	sll	a2,a2,0x20
    800001e4:	9201                	srl	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	add	a1,a1,1
    800001ee:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd291>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	add	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	sll	a3,a2,0x20
    80000206:	9281                	srl	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addw	a5,a2,-1
    80000216:	1782                	sll	a5,a5,0x20
    80000218:	9381                	srl	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	add	a4,a4,-1
    80000222:	16fd                	add	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	add	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	add	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addw	a2,a2,-1
    80000262:	0505                	add	a0,a0,1
    80000264:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	add	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	add	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	add	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	add	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	add	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	add	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	add	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addw	a3,a2,-1
    800002ca:	1682                	sll	a3,a3,0x20
    800002cc:	9281                	srl	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	add	a1,a1,1
    800002d8:	0785                	add	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	add	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	add	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	add	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	add	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	add	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	add	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	bba080e7          	jalr	-1094(ra) # 80000eda <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	00008717          	auipc	a4,0x8
    8000032c:	5a870713          	add	a4,a4,1448 # 800088d0 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b9e080e7          	jalr	-1122(ra) # 80000eda <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	add	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	a8e080e7          	jalr	-1394(ra) # 80005ddc <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	84c080e7          	jalr	-1972(ra) # 80001baa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	ece080e7          	jalr	-306(ra) # 80005234 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	094080e7          	jalr	148(ra) # 80001402 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	92c080e7          	jalr	-1748(ra) # 80005ca2 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	c66080e7          	jalr	-922(ra) # 80005fe4 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	add	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	a4e080e7          	jalr	-1458(ra) # 80005ddc <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	add	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	a3e080e7          	jalr	-1474(ra) # 80005ddc <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	add	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	a2e080e7          	jalr	-1490(ra) # 80005ddc <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	34a080e7          	jalr	842(ra) # 80000708 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	a4a080e7          	jalr	-1462(ra) # 80000e18 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	7ac080e7          	jalr	1964(ra) # 80001b82 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7cc080e7          	jalr	1996(ra) # 80001baa <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	e34080e7          	jalr	-460(ra) # 8000521a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e46080e7          	jalr	-442(ra) # 80005234 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	f0a080e7          	jalr	-246(ra) # 80002300 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	5c0080e7          	jalr	1472(ra) # 800029be <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	570080e7          	jalr	1392(ra) # 80003976 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	f2e080e7          	jalr	-210(ra) # 8000533c <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	dcc080e7          	jalr	-564(ra) # 800011e2 <userinit>
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	00008717          	auipc	a4,0x8
    80000428:	4af72623          	sw	a5,1196(a4) # 800088d0 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	add	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000434:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000438:	00008797          	auipc	a5,0x8
    8000043c:	4a07b783          	ld	a5,1184(a5) # 800088d8 <kernel_pagetable>
    80000440:	83b1                	srl	a5,a5,0xc
    80000442:	577d                	li	a4,-1
    80000444:	177e                	sll	a4,a4,0x3f
    80000446:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000448:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	add	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000456:	7139                	add	sp,sp,-64
    80000458:	fc06                	sd	ra,56(sp)
    8000045a:	f822                	sd	s0,48(sp)
    8000045c:	f426                	sd	s1,40(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	ec4e                	sd	s3,24(sp)
    80000462:	e852                	sd	s4,16(sp)
    80000464:	e456                	sd	s5,8(sp)
    80000466:	e05a                	sd	s6,0(sp)
    80000468:	0080                	add	s0,sp,64
    8000046a:	84aa                	mv	s1,a0
    8000046c:	89ae                	mv	s3,a1
    8000046e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000470:	57fd                	li	a5,-1
    80000472:	83e9                	srl	a5,a5,0x1a
    80000474:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000476:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000478:	04b7f263          	bgeu	a5,a1,800004bc <walk+0x66>
    panic("walk");
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bd450513          	add	a0,a0,-1068 # 80008050 <etext+0x50>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	90e080e7          	jalr	-1778(ra) # 80005d92 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048c:	060a8663          	beqz	s5,800004f8 <walk+0xa2>
    80000490:	00000097          	auipc	ra,0x0
    80000494:	c8a080e7          	jalr	-886(ra) # 8000011a <kalloc>
    80000498:	84aa                	mv	s1,a0
    8000049a:	c529                	beqz	a0,800004e4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049c:	6605                	lui	a2,0x1
    8000049e:	4581                	li	a1,0
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a8:	00c4d793          	srl	a5,s1,0xc
    800004ac:	07aa                	sll	a5,a5,0xa
    800004ae:	0017e793          	or	a5,a5,1
    800004b2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b6:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd287>
    800004b8:	036a0063          	beq	s4,s6,800004d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004bc:	0149d933          	srl	s2,s3,s4
    800004c0:	1ff97913          	and	s2,s2,511
    800004c4:	090e                	sll	s2,s2,0x3
    800004c6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c8:	00093483          	ld	s1,0(s2)
    800004cc:	0014f793          	and	a5,s1,1
    800004d0:	dfd5                	beqz	a5,8000048c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d2:	80a9                	srl	s1,s1,0xa
    800004d4:	04b2                	sll	s1,s1,0xc
    800004d6:	b7c5                	j	800004b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d8:	00c9d513          	srl	a0,s3,0xc
    800004dc:	1ff57513          	and	a0,a0,511
    800004e0:	050e                	sll	a0,a0,0x3
    800004e2:	9526                	add	a0,a0,s1
}
    800004e4:	70e2                	ld	ra,56(sp)
    800004e6:	7442                	ld	s0,48(sp)
    800004e8:	74a2                	ld	s1,40(sp)
    800004ea:	7902                	ld	s2,32(sp)
    800004ec:	69e2                	ld	s3,24(sp)
    800004ee:	6a42                	ld	s4,16(sp)
    800004f0:	6aa2                	ld	s5,8(sp)
    800004f2:	6b02                	ld	s6,0(sp)
    800004f4:	6121                	add	sp,sp,64
    800004f6:	8082                	ret
        return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7ed                	j	800004e4 <walk+0x8e>

00000000800004fc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srl	a5,a5,0x1a
    80000500:	00b7f463          	bgeu	a5,a1,80000508 <walkaddr+0xc>
    return 0;
    80000504:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000506:	8082                	ret
{
    80000508:	1141                	add	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000510:	4601                	li	a2,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	f44080e7          	jalr	-188(ra) # 80000456 <walk>
  if(pte == 0)
    8000051a:	c105                	beqz	a0,8000053a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051e:	0117f693          	and	a3,a5,17
    80000522:	4745                	li	a4,17
    return 0;
    80000524:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000526:	00e68663          	beq	a3,a4,80000532 <walkaddr+0x36>
}
    8000052a:	60a2                	ld	ra,8(sp)
    8000052c:	6402                	ld	s0,0(sp)
    8000052e:	0141                	add	sp,sp,16
    80000530:	8082                	ret
  pa = PTE2PA(*pte);
    80000532:	83a9                	srl	a5,a5,0xa
    80000534:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000538:	bfcd                	j	8000052a <walkaddr+0x2e>
    return 0;
    8000053a:	4501                	li	a0,0
    8000053c:	b7fd                	j	8000052a <walkaddr+0x2e>

000000008000053e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053e:	715d                	add	sp,sp,-80
    80000540:	e486                	sd	ra,72(sp)
    80000542:	e0a2                	sd	s0,64(sp)
    80000544:	fc26                	sd	s1,56(sp)
    80000546:	f84a                	sd	s2,48(sp)
    80000548:	f44e                	sd	s3,40(sp)
    8000054a:	f052                	sd	s4,32(sp)
    8000054c:	ec56                	sd	s5,24(sp)
    8000054e:	e85a                	sd	s6,16(sp)
    80000550:	e45e                	sd	s7,8(sp)
    80000552:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000554:	03459793          	sll	a5,a1,0x34
    80000558:	e7b9                	bnez	a5,800005a6 <mappages+0x68>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000055e:	03461793          	sll	a5,a2,0x34
    80000562:	ebb1                	bnez	a5,800005b6 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    80000564:	c22d                	beqz	a2,800005c6 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000566:	77fd                	lui	a5,0xfffff
    80000568:	963e                	add	a2,a2,a5
    8000056a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000056e:	892e                	mv	s2,a1
    80000570:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	ed6080e7          	jalr	-298(ra) # 80000456 <walk>
    80000588:	cd39                	beqz	a0,800005e6 <mappages+0xa8>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	and	a5,a5,1
    8000058e:	e7a1                	bnez	a5,800005d6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srl	s1,s1,0xc
    80000592:	04aa                	sll	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	or	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	07390063          	beq	s2,s3,800005fe <mappages+0xc0>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x38>
    panic("mappages: va not aligned");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	add	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	7e4080e7          	jalr	2020(ra) # 80005d92 <panic>
    panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	add	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	7d4080e7          	jalr	2004(ra) # 80005d92 <panic>
    panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	add	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00005097          	auipc	ra,0x5
    800005d2:	7c4080e7          	jalr	1988(ra) # 80005d92 <panic>
      panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	add	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00005097          	auipc	ra,0x5
    800005e2:	7b4080e7          	jalr	1972(ra) # 80005d92 <panic>
      return -1;
    800005e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e8:	60a6                	ld	ra,72(sp)
    800005ea:	6406                	ld	s0,64(sp)
    800005ec:	74e2                	ld	s1,56(sp)
    800005ee:	7942                	ld	s2,48(sp)
    800005f0:	79a2                	ld	s3,40(sp)
    800005f2:	7a02                	ld	s4,32(sp)
    800005f4:	6ae2                	ld	s5,24(sp)
    800005f6:	6b42                	ld	s6,16(sp)
    800005f8:	6ba2                	ld	s7,8(sp)
    800005fa:	6161                	add	sp,sp,80
    800005fc:	8082                	ret
  return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7e5                	j	800005e8 <mappages+0xaa>

0000000080000602 <kvmmap>:
{
    80000602:	1141                	add	sp,sp,-16
    80000604:	e406                	sd	ra,8(sp)
    80000606:	e022                	sd	s0,0(sp)
    80000608:	0800                	add	s0,sp,16
    8000060a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060c:	86b2                	mv	a3,a2
    8000060e:	863e                	mv	a2,a5
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2e080e7          	jalr	-210(ra) # 8000053e <mappages>
    80000618:	e509                	bnez	a0,80000622 <kvmmap+0x20>
}
    8000061a:	60a2                	ld	ra,8(sp)
    8000061c:	6402                	ld	s0,0(sp)
    8000061e:	0141                	add	sp,sp,16
    80000620:	8082                	ret
    panic("kvmmap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a9650513          	add	a0,a0,-1386 # 800080b8 <etext+0xb8>
    8000062a:	00005097          	auipc	ra,0x5
    8000062e:	768080e7          	jalr	1896(ra) # 80005d92 <panic>

0000000080000632 <kvmmake>:
{
    80000632:	1101                	add	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	e426                	sd	s1,8(sp)
    8000063a:	e04a                	sd	s2,0(sp)
    8000063c:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80000646:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	b2e080e7          	jalr	-1234(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10000637          	lui	a2,0x10000
    8000065c:	100005b7          	lui	a1,0x10000
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	fa0080e7          	jalr	-96(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	6685                	lui	a3,0x1
    8000066e:	10001637          	lui	a2,0x10001
    80000672:	100015b7          	lui	a1,0x10001
    80000676:	8526                	mv	a0,s1
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f8a080e7          	jalr	-118(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	004006b7          	lui	a3,0x400
    80000686:	0c000637          	lui	a2,0xc000
    8000068a:	0c0005b7          	lui	a1,0xc000
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f72080e7          	jalr	-142(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000698:	00008917          	auipc	s2,0x8
    8000069c:	96890913          	add	s2,s2,-1688 # 80008000 <etext>
    800006a0:	4729                	li	a4,10
    800006a2:	80008697          	auipc	a3,0x80008
    800006a6:	95e68693          	add	a3,a3,-1698 # 8000 <_entry-0x7fff8000>
    800006aa:	4605                	li	a2,1
    800006ac:	067e                	sll	a2,a2,0x1f
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f50080e7          	jalr	-176(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	sll	a3,a3,0x1b
    800006be:	4719                	li	a4,6
    800006c0:	412686b3          	sub	a3,a3,s2
    800006c4:	864a                	mv	a2,s2
    800006c6:	85ca                	mv	a1,s2
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f38080e7          	jalr	-200(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d2:	4729                	li	a4,10
    800006d4:	6685                	lui	a3,0x1
    800006d6:	00007617          	auipc	a2,0x7
    800006da:	92a60613          	add	a2,a2,-1750 # 80007000 <_trampoline>
    800006de:	040005b7          	lui	a1,0x4000
    800006e2:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e4:	05b2                	sll	a1,a1,0xc
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f1a080e7          	jalr	-230(ra) # 80000602 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	682080e7          	jalr	1666(ra) # 80000d74 <proc_mapstacks>
}
    800006fa:	8526                	mv	a0,s1
    800006fc:	60e2                	ld	ra,24(sp)
    800006fe:	6442                	ld	s0,16(sp)
    80000700:	64a2                	ld	s1,8(sp)
    80000702:	6902                	ld	s2,0(sp)
    80000704:	6105                	add	sp,sp,32
    80000706:	8082                	ret

0000000080000708 <kvminit>:
{
    80000708:	1141                	add	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f22080e7          	jalr	-222(ra) # 80000632 <kvmmake>
    80000718:	00008797          	auipc	a5,0x8
    8000071c:	1ca7b023          	sd	a0,448(a5) # 800088d8 <kernel_pagetable>
}
    80000720:	60a2                	ld	ra,8(sp)
    80000722:	6402                	ld	s0,0(sp)
    80000724:	0141                	add	sp,sp,16
    80000726:	8082                	ret

0000000080000728 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000728:	715d                	add	sp,sp,-80
    8000072a:	e486                	sd	ra,72(sp)
    8000072c:	e0a2                	sd	s0,64(sp)
    8000072e:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000730:	03459793          	sll	a5,a1,0x34
    80000734:	e39d                	bnez	a5,8000075a <uvmunmap+0x32>
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	8a2a                	mv	s4,a0
    80000744:	892e                	mv	s2,a1
    80000746:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000748:	0632                	sll	a2,a2,0xc
    8000074a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000074e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	6b05                	lui	s6,0x1
    80000752:	0935fb63          	bgeu	a1,s3,800007e8 <uvmunmap+0xc0>
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	a8a9                	j	800007b2 <uvmunmap+0x8a>
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	95850513          	add	a0,a0,-1704 # 800080c0 <etext+0xc0>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	622080e7          	jalr	1570(ra) # 80005d92 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	add	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	612080e7          	jalr	1554(ra) # 80005d92 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	add	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	602080e7          	jalr	1538(ra) # 80005d92 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	add	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	5f2080e7          	jalr	1522(ra) # 80005d92 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007a8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ac:	995a                	add	s2,s2,s6
    800007ae:	03397c63          	bgeu	s2,s3,800007e6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007b2:	4601                	li	a2,0
    800007b4:	85ca                	mv	a1,s2
    800007b6:	8552                	mv	a0,s4
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	c9e080e7          	jalr	-866(ra) # 80000456 <walk>
    800007c0:	84aa                	mv	s1,a0
    800007c2:	d95d                	beqz	a0,80000778 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007c4:	6108                	ld	a0,0(a0)
    800007c6:	00157793          	and	a5,a0,1
    800007ca:	dfdd                	beqz	a5,80000788 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007cc:	3ff57793          	and	a5,a0,1023
    800007d0:	fd7784e3          	beq	a5,s7,80000798 <uvmunmap+0x70>
    if(do_free){
    800007d4:	fc0a8ae3          	beqz	s5,800007a8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d8:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800007da:	0532                	sll	a0,a0,0xc
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	840080e7          	jalr	-1984(ra) # 8000001c <kfree>
    800007e4:	b7d1                	j	800007a8 <uvmunmap+0x80>
    800007e6:	74e2                	ld	s1,56(sp)
    800007e8:	7942                	ld	s2,48(sp)
    800007ea:	79a2                	ld	s3,40(sp)
    800007ec:	7a02                	ld	s4,32(sp)
    800007ee:	6ae2                	ld	s5,24(sp)
    800007f0:	6b42                	ld	s6,16(sp)
    800007f2:	6ba2                	ld	s7,8(sp)
  }
}
    800007f4:	60a6                	ld	ra,72(sp)
    800007f6:	6406                	ld	s0,64(sp)
    800007f8:	6161                	add	sp,sp,80
    800007fa:	8082                	ret

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fc:	1101                	add	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	914080e7          	jalr	-1772(ra) # 8000011a <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	add	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000082a:	7179                	add	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	926080e7          	jalr	-1754(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	cd8080e7          	jalr	-808(ra) # 8000053e <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	962080e7          	jalr	-1694(ra) # 800001d6 <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	add	sp,sp,48
    8000088a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	88c50513          	add	a0,a0,-1908 # 80008118 <etext+0x118>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	4fe080e7          	jalr	1278(ra) # 80005d92 <panic>

000000008000089c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089c:	1101                	add	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	76fd                	lui	a3,0xfffff
    800008b8:	8f75                	and	a4,a4,a3
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff5                	and	a5,a5,a3
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	add	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e4e080e7          	jalr	-434(ra) # 80000728 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if(newsz < oldsz)
    800008e4:	0ab66b63          	bltu	a2,a1,8000099a <uvmalloc+0xb6>
{
    800008e8:	7139                	add	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	add	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6785                	lui	a5,0x1
    800008fc:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fe:	95be                	add	a1,a1,a5
    80000900:	77fd                	lui	a5,0xfffff
    80000902:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	08c9fc63          	bgeu	s3,a2,8000099e <uvmalloc+0xba>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	e05a                	sd	s6,0(sp)
    80000910:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000912:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	804080e7          	jalr	-2044(ra) # 8000011a <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000920:	c915                	beqz	a0,80000954 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c06080e7          	jalr	-1018(ra) # 8000053e <mappages>
    80000940:	ed05                	bnez	a0,80000978 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	74a2                	ld	s1,40(sp)
    8000094e:	7902                	ld	s2,32(sp)
    80000950:	6b02                	ld	s6,0(sp)
    80000952:	a821                	j	8000096a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000954:	864e                	mv	a2,s3
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f42080e7          	jalr	-190(ra) # 8000089c <uvmdealloc>
      return 0;
    80000962:	4501                	li	a0,0
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	7902                	ld	s2,32(sp)
    80000968:	6b02                	ld	s6,0(sp)
}
    8000096a:	70e2                	ld	ra,56(sp)
    8000096c:	7442                	ld	s0,48(sp)
    8000096e:	69e2                	ld	s3,24(sp)
    80000970:	6a42                	ld	s4,16(sp)
    80000972:	6aa2                	ld	s5,8(sp)
    80000974:	6121                	add	sp,sp,64
    80000976:	8082                	ret
      kfree(mem);
    80000978:	8526                	mv	a0,s1
    8000097a:	fffff097          	auipc	ra,0xfffff
    8000097e:	6a2080e7          	jalr	1698(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000982:	864e                	mv	a2,s3
    80000984:	85ca                	mv	a1,s2
    80000986:	8556                	mv	a0,s5
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	f14080e7          	jalr	-236(ra) # 8000089c <uvmdealloc>
      return 0;
    80000990:	4501                	li	a0,0
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	6b02                	ld	s6,0(sp)
    80000998:	bfc9                	j	8000096a <uvmalloc+0x86>
    return oldsz;
    8000099a:	852e                	mv	a0,a1
}
    8000099c:	8082                	ret
  return newsz;
    8000099e:	8532                	mv	a0,a2
    800009a0:	b7e9                	j	8000096a <uvmalloc+0x86>

00000000800009a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a2:	7179                	add	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	add	s0,sp,48
    800009b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b4:	84aa                	mv	s1,a0
    800009b6:	6905                	lui	s2,0x1
    800009b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ba:	4985                	li	s3,1
    800009bc:	a829                	j	800009d6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009be:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c0:	00c79513          	sll	a0,a5,0xc
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	fde080e7          	jalr	-34(ra) # 800009a2 <freewalk>
      pagetable[i] = 0;
    800009cc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d0:	04a1                	add	s1,s1,8
    800009d2:	03248163          	beq	s1,s2,800009f4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d8:	00f7f713          	and	a4,a5,15
    800009dc:	ff3701e3          	beq	a4,s3,800009be <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e0:	8b85                	and	a5,a5,1
    800009e2:	d7fd                	beqz	a5,800009d0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e4:	00007517          	auipc	a0,0x7
    800009e8:	75450513          	add	a0,a0,1876 # 80008138 <etext+0x138>
    800009ec:	00005097          	auipc	ra,0x5
    800009f0:	3a6080e7          	jalr	934(ra) # 80005d92 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f4:	8552                	mv	a0,s4
    800009f6:	fffff097          	auipc	ra,0xfffff
    800009fa:	626080e7          	jalr	1574(ra) # 8000001c <kfree>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	add	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a0e:	1101                	add	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	1000                	add	s0,sp,32
    80000a18:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a1a:	e999                	bnez	a1,80000a30 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	f84080e7          	jalr	-124(ra) # 800009a2 <freewalk>
}
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	add	sp,sp,32
    80000a2e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	95be                	add	a1,a1,a5
    80000a36:	4685                	li	a3,1
    80000a38:	00c5d613          	srl	a2,a1,0xc
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	cea080e7          	jalr	-790(ra) # 80000728 <uvmunmap>
    80000a46:	bfd9                	j	80000a1c <uvmfree+0xe>

0000000080000a48 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a48:	c679                	beqz	a2,80000b16 <uvmcopy+0xce>
{
    80000a4a:	715d                	add	sp,sp,-80
    80000a4c:	e486                	sd	ra,72(sp)
    80000a4e:	e0a2                	sd	s0,64(sp)
    80000a50:	fc26                	sd	s1,56(sp)
    80000a52:	f84a                	sd	s2,48(sp)
    80000a54:	f44e                	sd	s3,40(sp)
    80000a56:	f052                	sd	s4,32(sp)
    80000a58:	ec56                	sd	s5,24(sp)
    80000a5a:	e85a                	sd	s6,16(sp)
    80000a5c:	e45e                	sd	s7,8(sp)
    80000a5e:	0880                	add	s0,sp,80
    80000a60:	8b2a                	mv	s6,a0
    80000a62:	8aae                	mv	s5,a1
    80000a64:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a66:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a68:	4601                	li	a2,0
    80000a6a:	85ce                	mv	a1,s3
    80000a6c:	855a                	mv	a0,s6
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	9e8080e7          	jalr	-1560(ra) # 80000456 <walk>
    80000a76:	c531                	beqz	a0,80000ac2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a78:	6118                	ld	a4,0(a0)
    80000a7a:	00177793          	and	a5,a4,1
    80000a7e:	cbb1                	beqz	a5,80000ad2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a80:	00a75593          	srl	a1,a4,0xa
    80000a84:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a88:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	68e080e7          	jalr	1678(ra) # 8000011a <kalloc>
    80000a94:	892a                	mv	s2,a0
    80000a96:	c939                	beqz	a0,80000aec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85de                	mv	a1,s7
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	73a080e7          	jalr	1850(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa4:	8726                	mv	a4,s1
    80000aa6:	86ca                	mv	a3,s2
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	8556                	mv	a0,s5
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	a90080e7          	jalr	-1392(ra) # 8000053e <mappages>
    80000ab6:	e515                	bnez	a0,80000ae2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	99be                	add	s3,s3,a5
    80000abc:	fb49e6e3          	bltu	s3,s4,80000a68 <uvmcopy+0x20>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	68650513          	add	a0,a0,1670 # 80008148 <etext+0x148>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	2c8080e7          	jalr	712(ra) # 80005d92 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	69650513          	add	a0,a0,1686 # 80008168 <etext+0x168>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	2b8080e7          	jalr	696(ra) # 80005d92 <panic>
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srl	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	8556                	mv	a0,s5
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c32080e7          	jalr	-974(ra) # 80000728 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6161                	add	sp,sp,80
    80000b14:	8082                	ret
  return 0;
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret

0000000080000b1a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1a:	1141                	add	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b22:	4601                	li	a2,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	932080e7          	jalr	-1742(ra) # 80000456 <walk>
  if(pte == 0)
    80000b2c:	c901                	beqz	a0,80000b3c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b2e:	611c                	ld	a5,0(a0)
    80000b30:	9bbd                	and	a5,a5,-17
    80000b32:	e11c                	sd	a5,0(a0)
}
    80000b34:	60a2                	ld	ra,8(sp)
    80000b36:	6402                	ld	s0,0(sp)
    80000b38:	0141                	add	sp,sp,16
    80000b3a:	8082                	ret
    panic("uvmclear");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	64c50513          	add	a0,a0,1612 # 80008188 <etext+0x188>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	24e080e7          	jalr	590(ra) # 80005d92 <panic>

0000000080000b4c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b4c:	ced1                	beqz	a3,80000be8 <copyout+0x9c>
{
    80000b4e:	711d                	add	sp,sp,-96
    80000b50:	ec86                	sd	ra,88(sp)
    80000b52:	e8a2                	sd	s0,80(sp)
    80000b54:	e4a6                	sd	s1,72(sp)
    80000b56:	fc4e                	sd	s3,56(sp)
    80000b58:	f456                	sd	s5,40(sp)
    80000b5a:	f05a                	sd	s6,32(sp)
    80000b5c:	ec5e                	sd	s7,24(sp)
    80000b5e:	1080                	add	s0,sp,96
    80000b60:	8baa                	mv	s7,a0
    80000b62:	8aae                	mv	s5,a1
    80000b64:	8b32                	mv	s6,a2
    80000b66:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b68:	74fd                	lui	s1,0xfffff
    80000b6a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b6c:	57fd                	li	a5,-1
    80000b6e:	83e9                	srl	a5,a5,0x1a
    80000b70:	0697ee63          	bltu	a5,s1,80000bec <copyout+0xa0>
    80000b74:	e0ca                	sd	s2,64(sp)
    80000b76:	f852                	sd	s4,48(sp)
    80000b78:	e862                	sd	s8,16(sp)
    80000b7a:	e466                	sd	s9,8(sp)
    80000b7c:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b7e:	4cd5                	li	s9,21
    80000b80:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b82:	8c3e                	mv	s8,a5
    80000b84:	a035                	j	80000bb0 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b86:	83a9                	srl	a5,a5,0xa
    80000b88:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	409a8533          	sub	a0,s5,s1
    80000b8e:	0009061b          	sext.w	a2,s2
    80000b92:	85da                	mv	a1,s6
    80000b94:	953e                	add	a0,a0,a5
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>

    len -= n;
    80000b9e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000ba2:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000ba4:	02098b63          	beqz	s3,80000bda <copyout+0x8e>
    if(va0 >= MAXVA)
    80000ba8:	054c6463          	bltu	s8,s4,80000bf0 <copyout+0xa4>
    80000bac:	84d2                	mv	s1,s4
    80000bae:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bb0:	4601                	li	a2,0
    80000bb2:	85a6                	mv	a1,s1
    80000bb4:	855e                	mv	a0,s7
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	8a0080e7          	jalr	-1888(ra) # 80000456 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bbe:	c121                	beqz	a0,80000bfe <copyout+0xb2>
    80000bc0:	611c                	ld	a5,0(a0)
    80000bc2:	0157f713          	and	a4,a5,21
    80000bc6:	05971b63          	bne	a4,s9,80000c1c <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000bca:	01a48a33          	add	s4,s1,s10
    80000bce:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bd2:	fb29fae3          	bgeu	s3,s2,80000b86 <copyout+0x3a>
    80000bd6:	894e                	mv	s2,s3
    80000bd8:	b77d                	j	80000b86 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	7a42                	ld	s4,48(sp)
    80000be0:	6c42                	ld	s8,16(sp)
    80000be2:	6ca2                	ld	s9,8(sp)
    80000be4:	6d02                	ld	s10,0(sp)
    80000be6:	a015                	j	80000c0a <copyout+0xbe>
    80000be8:	4501                	li	a0,0
}
    80000bea:	8082                	ret
      return -1;
    80000bec:	557d                	li	a0,-1
    80000bee:	a831                	j	80000c0a <copyout+0xbe>
    80000bf0:	557d                	li	a0,-1
    80000bf2:	6906                	ld	s2,64(sp)
    80000bf4:	7a42                	ld	s4,48(sp)
    80000bf6:	6c42                	ld	s8,16(sp)
    80000bf8:	6ca2                	ld	s9,8(sp)
    80000bfa:	6d02                	ld	s10,0(sp)
    80000bfc:	a039                	j	80000c0a <copyout+0xbe>
      return -1;
    80000bfe:	557d                	li	a0,-1
    80000c00:	6906                	ld	s2,64(sp)
    80000c02:	7a42                	ld	s4,48(sp)
    80000c04:	6c42                	ld	s8,16(sp)
    80000c06:	6ca2                	ld	s9,8(sp)
    80000c08:	6d02                	ld	s10,0(sp)
}
    80000c0a:	60e6                	ld	ra,88(sp)
    80000c0c:	6446                	ld	s0,80(sp)
    80000c0e:	64a6                	ld	s1,72(sp)
    80000c10:	79e2                	ld	s3,56(sp)
    80000c12:	7aa2                	ld	s5,40(sp)
    80000c14:	7b02                	ld	s6,32(sp)
    80000c16:	6be2                	ld	s7,24(sp)
    80000c18:	6125                	add	sp,sp,96
    80000c1a:	8082                	ret
      return -1;
    80000c1c:	557d                	li	a0,-1
    80000c1e:	6906                	ld	s2,64(sp)
    80000c20:	7a42                	ld	s4,48(sp)
    80000c22:	6c42                	ld	s8,16(sp)
    80000c24:	6ca2                	ld	s9,8(sp)
    80000c26:	6d02                	ld	s10,0(sp)
    80000c28:	b7cd                	j	80000c0a <copyout+0xbe>

0000000080000c2a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c2a:	caa5                	beqz	a3,80000c9a <copyin+0x70>
{
    80000c2c:	715d                	add	sp,sp,-80
    80000c2e:	e486                	sd	ra,72(sp)
    80000c30:	e0a2                	sd	s0,64(sp)
    80000c32:	fc26                	sd	s1,56(sp)
    80000c34:	f84a                	sd	s2,48(sp)
    80000c36:	f44e                	sd	s3,40(sp)
    80000c38:	f052                	sd	s4,32(sp)
    80000c3a:	ec56                	sd	s5,24(sp)
    80000c3c:	e85a                	sd	s6,16(sp)
    80000c3e:	e45e                	sd	s7,8(sp)
    80000c40:	e062                	sd	s8,0(sp)
    80000c42:	0880                	add	s0,sp,80
    80000c44:	8b2a                	mv	s6,a0
    80000c46:	8a2e                	mv	s4,a1
    80000c48:	8c32                	mv	s8,a2
    80000c4a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6a85                	lui	s5,0x1
    80000c50:	a01d                	j	80000c76 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c52:	018505b3          	add	a1,a0,s8
    80000c56:	0004861b          	sext.w	a2,s1
    80000c5a:	412585b3          	sub	a1,a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	fffff097          	auipc	ra,0xfffff
    80000c64:	576080e7          	jalr	1398(ra) # 800001d6 <memmove>

    len -= n;
    80000c68:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c6c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c6e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c72:	02098263          	beqz	s3,80000c96 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7a:	85ca                	mv	a1,s2
    80000c7c:	855a                	mv	a0,s6
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	87e080e7          	jalr	-1922(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000c86:	cd01                	beqz	a0,80000c9e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c88:	418904b3          	sub	s1,s2,s8
    80000c8c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c8e:	fc99f2e3          	bgeu	s3,s1,80000c52 <copyin+0x28>
    80000c92:	84ce                	mv	s1,s3
    80000c94:	bf7d                	j	80000c52 <copyin+0x28>
  }
  return 0;
    80000c96:	4501                	li	a0,0
    80000c98:	a021                	j	80000ca0 <copyin+0x76>
    80000c9a:	4501                	li	a0,0
}
    80000c9c:	8082                	ret
      return -1;
    80000c9e:	557d                	li	a0,-1
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6c02                	ld	s8,0(sp)
    80000cb4:	6161                	add	sp,sp,80
    80000cb6:	8082                	ret

0000000080000cb8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cb8:	cacd                	beqz	a3,80000d6a <copyinstr+0xb2>
{
    80000cba:	715d                	add	sp,sp,-80
    80000cbc:	e486                	sd	ra,72(sp)
    80000cbe:	e0a2                	sd	s0,64(sp)
    80000cc0:	fc26                	sd	s1,56(sp)
    80000cc2:	f84a                	sd	s2,48(sp)
    80000cc4:	f44e                	sd	s3,40(sp)
    80000cc6:	f052                	sd	s4,32(sp)
    80000cc8:	ec56                	sd	s5,24(sp)
    80000cca:	e85a                	sd	s6,16(sp)
    80000ccc:	e45e                	sd	s7,8(sp)
    80000cce:	0880                	add	s0,sp,80
    80000cd0:	8a2a                	mv	s4,a0
    80000cd2:	8b2e                	mv	s6,a1
    80000cd4:	8bb2                	mv	s7,a2
    80000cd6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cda:	6985                	lui	s3,0x1
    80000cdc:	a825                	j	80000d14 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cde:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ce4:	37fd                	addw	a5,a5,-1
    80000ce6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6161                	add	sp,sp,80
    80000cfe:	8082                	ret
    80000d00:	fff90713          	add	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d04:	9742                	add	a4,a4,a6
      --max;
    80000d06:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d0a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d0e:	04e58663          	beq	a1,a4,80000d5a <copyinstr+0xa2>
{
    80000d12:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d14:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	7e0080e7          	jalr	2016(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000d24:	cd0d                	beqz	a0,80000d5e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d26:	417486b3          	sub	a3,s1,s7
    80000d2a:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d2c:	00d97363          	bgeu	s2,a3,80000d32 <copyinstr+0x7a>
    80000d30:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d32:	955e                	add	a0,a0,s7
    80000d34:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d36:	c695                	beqz	a3,80000d62 <copyinstr+0xaa>
    80000d38:	87da                	mv	a5,s6
    80000d3a:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d3c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d40:	96da                	add	a3,a3,s6
    80000d42:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d44:	00f60733          	add	a4,a2,a5
    80000d48:	00074703          	lbu	a4,0(a4)
    80000d4c:	db49                	beqz	a4,80000cde <copyinstr+0x26>
        *dst = *p;
    80000d4e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d52:	0785                	add	a5,a5,1
    while(n > 0){
    80000d54:	fed797e3          	bne	a5,a3,80000d42 <copyinstr+0x8a>
    80000d58:	b765                	j	80000d00 <copyinstr+0x48>
    80000d5a:	4781                	li	a5,0
    80000d5c:	b761                	j	80000ce4 <copyinstr+0x2c>
      return -1;
    80000d5e:	557d                	li	a0,-1
    80000d60:	b769                	j	80000cea <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d62:	6b85                	lui	s7,0x1
    80000d64:	9ba6                	add	s7,s7,s1
    80000d66:	87da                	mv	a5,s6
    80000d68:	b76d                	j	80000d12 <copyinstr+0x5a>
  int got_null = 0;
    80000d6a:	4781                	li	a5,0
  if(got_null){
    80000d6c:	37fd                	addw	a5,a5,-1
    80000d6e:	0007851b          	sext.w	a0,a5
}
    80000d72:	8082                	ret

0000000080000d74 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d74:	7139                	add	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	add	s0,sp,64
    80000d88:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	00008497          	auipc	s1,0x8
    80000d8e:	fc648493          	add	s1,s1,-58 # 80008d50 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d92:	8b26                	mv	s6,s1
    80000d94:	04fa5937          	lui	s2,0x4fa5
    80000d98:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d9c:	0932                	sll	s2,s2,0xc
    80000d9e:	fa590913          	add	s2,s2,-91
    80000da2:	0932                	sll	s2,s2,0xc
    80000da4:	fa590913          	add	s2,s2,-91
    80000da8:	0932                	sll	s2,s2,0xc
    80000daa:	fa590913          	add	s2,s2,-91
    80000dae:	040009b7          	lui	s3,0x4000
    80000db2:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000db4:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	0000ea97          	auipc	s5,0xe
    80000dba:	99aa8a93          	add	s5,s5,-1638 # 8000e750 <tickslock>
    char *pa = kalloc();
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80000dc6:	862a                	mv	a2,a0
    if(pa == 0)
    80000dc8:	c121                	beqz	a0,80000e08 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000dca:	416485b3          	sub	a1,s1,s6
    80000dce:	858d                	sra	a1,a1,0x3
    80000dd0:	032585b3          	mul	a1,a1,s2
    80000dd4:	2585                	addw	a1,a1,1
    80000dd6:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dda:	4719                	li	a4,6
    80000ddc:	6685                	lui	a3,0x1
    80000dde:	40b985b3          	sub	a1,s3,a1
    80000de2:	8552                	mv	a0,s4
    80000de4:	00000097          	auipc	ra,0x0
    80000de8:	81e080e7          	jalr	-2018(ra) # 80000602 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	16848493          	add	s1,s1,360
    80000df0:	fd5497e3          	bne	s1,s5,80000dbe <proc_mapstacks+0x4a>
  }
}
    80000df4:	70e2                	ld	ra,56(sp)
    80000df6:	7442                	ld	s0,48(sp)
    80000df8:	74a2                	ld	s1,40(sp)
    80000dfa:	7902                	ld	s2,32(sp)
    80000dfc:	69e2                	ld	s3,24(sp)
    80000dfe:	6a42                	ld	s4,16(sp)
    80000e00:	6aa2                	ld	s5,8(sp)
    80000e02:	6b02                	ld	s6,0(sp)
    80000e04:	6121                	add	sp,sp,64
    80000e06:	8082                	ret
      panic("kalloc");
    80000e08:	00007517          	auipc	a0,0x7
    80000e0c:	39050513          	add	a0,a0,912 # 80008198 <etext+0x198>
    80000e10:	00005097          	auipc	ra,0x5
    80000e14:	f82080e7          	jalr	-126(ra) # 80005d92 <panic>

0000000080000e18 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e18:	7139                	add	sp,sp,-64
    80000e1a:	fc06                	sd	ra,56(sp)
    80000e1c:	f822                	sd	s0,48(sp)
    80000e1e:	f426                	sd	s1,40(sp)
    80000e20:	f04a                	sd	s2,32(sp)
    80000e22:	ec4e                	sd	s3,24(sp)
    80000e24:	e852                	sd	s4,16(sp)
    80000e26:	e456                	sd	s5,8(sp)
    80000e28:	e05a                	sd	s6,0(sp)
    80000e2a:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e2c:	00007597          	auipc	a1,0x7
    80000e30:	37458593          	add	a1,a1,884 # 800081a0 <etext+0x1a0>
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	aec50513          	add	a0,a0,-1300 # 80008920 <pid_lock>
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	440080e7          	jalr	1088(ra) # 8000627c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e44:	00007597          	auipc	a1,0x7
    80000e48:	36458593          	add	a1,a1,868 # 800081a8 <etext+0x1a8>
    80000e4c:	00008517          	auipc	a0,0x8
    80000e50:	aec50513          	add	a0,a0,-1300 # 80008938 <wait_lock>
    80000e54:	00005097          	auipc	ra,0x5
    80000e58:	428080e7          	jalr	1064(ra) # 8000627c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5c:	00008497          	auipc	s1,0x8
    80000e60:	ef448493          	add	s1,s1,-268 # 80008d50 <proc>
      initlock(&p->lock, "proc");
    80000e64:	00007b17          	auipc	s6,0x7
    80000e68:	354b0b13          	add	s6,s6,852 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e6c:	8aa6                	mv	s5,s1
    80000e6e:	04fa5937          	lui	s2,0x4fa5
    80000e72:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e76:	0932                	sll	s2,s2,0xc
    80000e78:	fa590913          	add	s2,s2,-91
    80000e7c:	0932                	sll	s2,s2,0xc
    80000e7e:	fa590913          	add	s2,s2,-91
    80000e82:	0932                	sll	s2,s2,0xc
    80000e84:	fa590913          	add	s2,s2,-91
    80000e88:	040009b7          	lui	s3,0x4000
    80000e8c:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e8e:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e90:	0000ea17          	auipc	s4,0xe
    80000e94:	8c0a0a13          	add	s4,s4,-1856 # 8000e750 <tickslock>
      initlock(&p->lock, "proc");
    80000e98:	85da                	mv	a1,s6
    80000e9a:	8526                	mv	a0,s1
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	3e0080e7          	jalr	992(ra) # 8000627c <initlock>
      p->state = UNUSED;
    80000ea4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ea8:	415487b3          	sub	a5,s1,s5
    80000eac:	878d                	sra	a5,a5,0x3
    80000eae:	032787b3          	mul	a5,a5,s2
    80000eb2:	2785                	addw	a5,a5,1
    80000eb4:	00d7979b          	sllw	a5,a5,0xd
    80000eb8:	40f987b3          	sub	a5,s3,a5
    80000ebc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebe:	16848493          	add	s1,s1,360
    80000ec2:	fd449be3          	bne	s1,s4,80000e98 <procinit+0x80>
  }
}
    80000ec6:	70e2                	ld	ra,56(sp)
    80000ec8:	7442                	ld	s0,48(sp)
    80000eca:	74a2                	ld	s1,40(sp)
    80000ecc:	7902                	ld	s2,32(sp)
    80000ece:	69e2                	ld	s3,24(sp)
    80000ed0:	6a42                	ld	s4,16(sp)
    80000ed2:	6aa2                	ld	s5,8(sp)
    80000ed4:	6b02                	ld	s6,0(sp)
    80000ed6:	6121                	add	sp,sp,64
    80000ed8:	8082                	ret

0000000080000eda <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000eda:	1141                	add	sp,sp,-16
    80000edc:	e422                	sd	s0,8(sp)
    80000ede:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ee0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ee2:	2501                	sext.w	a0,a0
    80000ee4:	6422                	ld	s0,8(sp)
    80000ee6:	0141                	add	sp,sp,16
    80000ee8:	8082                	ret

0000000080000eea <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000eea:	1141                	add	sp,sp,-16
    80000eec:	e422                	sd	s0,8(sp)
    80000eee:	0800                	add	s0,sp,16
    80000ef0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ef2:	2781                	sext.w	a5,a5
    80000ef4:	079e                	sll	a5,a5,0x7
  return c;
}
    80000ef6:	00008517          	auipc	a0,0x8
    80000efa:	a5a50513          	add	a0,a0,-1446 # 80008950 <cpus>
    80000efe:	953e                	add	a0,a0,a5
    80000f00:	6422                	ld	s0,8(sp)
    80000f02:	0141                	add	sp,sp,16
    80000f04:	8082                	ret

0000000080000f06 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f06:	1101                	add	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	1000                	add	s0,sp,32
  push_off();
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	3b0080e7          	jalr	944(ra) # 800062c0 <push_off>
    80000f18:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f1a:	2781                	sext.w	a5,a5
    80000f1c:	079e                	sll	a5,a5,0x7
    80000f1e:	00008717          	auipc	a4,0x8
    80000f22:	a0270713          	add	a4,a4,-1534 # 80008920 <pid_lock>
    80000f26:	97ba                	add	a5,a5,a4
    80000f28:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	436080e7          	jalr	1078(ra) # 80006360 <pop_off>
  return p;
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6105                	add	sp,sp,32
    80000f3c:	8082                	ret

0000000080000f3e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f3e:	1141                	add	sp,sp,-16
    80000f40:	e406                	sd	ra,8(sp)
    80000f42:	e022                	sd	s0,0(sp)
    80000f44:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f46:	00000097          	auipc	ra,0x0
    80000f4a:	fc0080e7          	jalr	-64(ra) # 80000f06 <myproc>
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	472080e7          	jalr	1138(ra) # 800063c0 <release>

  if (first) {
    80000f56:	00008797          	auipc	a5,0x8
    80000f5a:	92a7a783          	lw	a5,-1750(a5) # 80008880 <first.1>
    80000f5e:	eb89                	bnez	a5,80000f70 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	c62080e7          	jalr	-926(ra) # 80001bc2 <usertrapret>
}
    80000f68:	60a2                	ld	ra,8(sp)
    80000f6a:	6402                	ld	s0,0(sp)
    80000f6c:	0141                	add	sp,sp,16
    80000f6e:	8082                	ret
    fsinit(ROOTDEV);
    80000f70:	4505                	li	a0,1
    80000f72:	00002097          	auipc	ra,0x2
    80000f76:	9cc080e7          	jalr	-1588(ra) # 8000293e <fsinit>
    first = 0;
    80000f7a:	00008797          	auipc	a5,0x8
    80000f7e:	9007a323          	sw	zero,-1786(a5) # 80008880 <first.1>
    __sync_synchronize();
    80000f82:	0ff0000f          	fence
    80000f86:	bfe9                	j	80000f60 <forkret+0x22>

0000000080000f88 <allocpid>:
{
    80000f88:	1101                	add	sp,sp,-32
    80000f8a:	ec06                	sd	ra,24(sp)
    80000f8c:	e822                	sd	s0,16(sp)
    80000f8e:	e426                	sd	s1,8(sp)
    80000f90:	e04a                	sd	s2,0(sp)
    80000f92:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000f94:	00008917          	auipc	s2,0x8
    80000f98:	98c90913          	add	s2,s2,-1652 # 80008920 <pid_lock>
    80000f9c:	854a                	mv	a0,s2
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	36e080e7          	jalr	878(ra) # 8000630c <acquire>
  pid = nextpid;
    80000fa6:	00008797          	auipc	a5,0x8
    80000faa:	8de78793          	add	a5,a5,-1826 # 80008884 <nextpid>
    80000fae:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fb0:	0014871b          	addw	a4,s1,1
    80000fb4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fb6:	854a                	mv	a0,s2
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	408080e7          	jalr	1032(ra) # 800063c0 <release>
}
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6902                	ld	s2,0(sp)
    80000fca:	6105                	add	sp,sp,32
    80000fcc:	8082                	ret

0000000080000fce <proc_pagetable>:
{
    80000fce:	1101                	add	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	e04a                	sd	s2,0(sp)
    80000fd8:	1000                	add	s0,sp,32
    80000fda:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	820080e7          	jalr	-2016(ra) # 800007fc <uvmcreate>
    80000fe4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fe6:	c121                	beqz	a0,80001026 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fe8:	4729                	li	a4,10
    80000fea:	00006697          	auipc	a3,0x6
    80000fee:	01668693          	add	a3,a3,22 # 80007000 <_trampoline>
    80000ff2:	6605                	lui	a2,0x1
    80000ff4:	040005b7          	lui	a1,0x4000
    80000ff8:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ffa:	05b2                	sll	a1,a1,0xc
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	542080e7          	jalr	1346(ra) # 8000053e <mappages>
    80001004:	02054863          	bltz	a0,80001034 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001008:	4719                	li	a4,6
    8000100a:	05893683          	ld	a3,88(s2)
    8000100e:	6605                	lui	a2,0x1
    80001010:	020005b7          	lui	a1,0x2000
    80001014:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001016:	05b6                	sll	a1,a1,0xd
    80001018:	8526                	mv	a0,s1
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	524080e7          	jalr	1316(ra) # 8000053e <mappages>
    80001022:	02054163          	bltz	a0,80001044 <proc_pagetable+0x76>
}
    80001026:	8526                	mv	a0,s1
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6902                	ld	s2,0(sp)
    80001030:	6105                	add	sp,sp,32
    80001032:	8082                	ret
    uvmfree(pagetable, 0);
    80001034:	4581                	li	a1,0
    80001036:	8526                	mv	a0,s1
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	9d6080e7          	jalr	-1578(ra) # 80000a0e <uvmfree>
    return 0;
    80001040:	4481                	li	s1,0
    80001042:	b7d5                	j	80001026 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	040005b7          	lui	a1,0x4000
    8000104c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104e:	05b2                	sll	a1,a1,0xc
    80001050:	8526                	mv	a0,s1
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	6d6080e7          	jalr	1750(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    8000105a:	4581                	li	a1,0
    8000105c:	8526                	mv	a0,s1
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	9b0080e7          	jalr	-1616(ra) # 80000a0e <uvmfree>
    return 0;
    80001066:	4481                	li	s1,0
    80001068:	bf7d                	j	80001026 <proc_pagetable+0x58>

000000008000106a <proc_freepagetable>:
{
    8000106a:	1101                	add	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	e04a                	sd	s2,0(sp)
    80001074:	1000                	add	s0,sp,32
    80001076:	84aa                	mv	s1,a0
    80001078:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000107a:	4681                	li	a3,0
    8000107c:	4605                	li	a2,1
    8000107e:	040005b7          	lui	a1,0x4000
    80001082:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001084:	05b2                	sll	a1,a1,0xc
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	6a2080e7          	jalr	1698(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000108e:	4681                	li	a3,0
    80001090:	4605                	li	a2,1
    80001092:	020005b7          	lui	a1,0x2000
    80001096:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001098:	05b6                	sll	a1,a1,0xd
    8000109a:	8526                	mv	a0,s1
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	68c080e7          	jalr	1676(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    800010a4:	85ca                	mv	a1,s2
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	966080e7          	jalr	-1690(ra) # 80000a0e <uvmfree>
}
    800010b0:	60e2                	ld	ra,24(sp)
    800010b2:	6442                	ld	s0,16(sp)
    800010b4:	64a2                	ld	s1,8(sp)
    800010b6:	6902                	ld	s2,0(sp)
    800010b8:	6105                	add	sp,sp,32
    800010ba:	8082                	ret

00000000800010bc <freeproc>:
{
    800010bc:	1101                	add	sp,sp,-32
    800010be:	ec06                	sd	ra,24(sp)
    800010c0:	e822                	sd	s0,16(sp)
    800010c2:	e426                	sd	s1,8(sp)
    800010c4:	1000                	add	s0,sp,32
    800010c6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010c8:	6d28                	ld	a0,88(a0)
    800010ca:	c509                	beqz	a0,800010d4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	f50080e7          	jalr	-176(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010d4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010d8:	68a8                	ld	a0,80(s1)
    800010da:	c511                	beqz	a0,800010e6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010dc:	64ac                	ld	a1,72(s1)
    800010de:	00000097          	auipc	ra,0x0
    800010e2:	f8c080e7          	jalr	-116(ra) # 8000106a <proc_freepagetable>
  p->pagetable = 0;
    800010e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010ee:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010f2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010f6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010fa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010fe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001102:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001106:	0004ac23          	sw	zero,24(s1)
}
    8000110a:	60e2                	ld	ra,24(sp)
    8000110c:	6442                	ld	s0,16(sp)
    8000110e:	64a2                	ld	s1,8(sp)
    80001110:	6105                	add	sp,sp,32
    80001112:	8082                	ret

0000000080001114 <allocproc>:
{
    80001114:	1101                	add	sp,sp,-32
    80001116:	ec06                	sd	ra,24(sp)
    80001118:	e822                	sd	s0,16(sp)
    8000111a:	e426                	sd	s1,8(sp)
    8000111c:	e04a                	sd	s2,0(sp)
    8000111e:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001120:	00008497          	auipc	s1,0x8
    80001124:	c3048493          	add	s1,s1,-976 # 80008d50 <proc>
    80001128:	0000d917          	auipc	s2,0xd
    8000112c:	62890913          	add	s2,s2,1576 # 8000e750 <tickslock>
    acquire(&p->lock);
    80001130:	8526                	mv	a0,s1
    80001132:	00005097          	auipc	ra,0x5
    80001136:	1da080e7          	jalr	474(ra) # 8000630c <acquire>
    if(p->state == UNUSED) {
    8000113a:	4c9c                	lw	a5,24(s1)
    8000113c:	cf81                	beqz	a5,80001154 <allocproc+0x40>
      release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	280080e7          	jalr	640(ra) # 800063c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001148:	16848493          	add	s1,s1,360
    8000114c:	ff2492e3          	bne	s1,s2,80001130 <allocproc+0x1c>
  return 0;
    80001150:	4481                	li	s1,0
    80001152:	a889                	j	800011a4 <allocproc+0x90>
  p->pid = allocpid();
    80001154:	00000097          	auipc	ra,0x0
    80001158:	e34080e7          	jalr	-460(ra) # 80000f88 <allocpid>
    8000115c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000115e:	4785                	li	a5,1
    80001160:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	fb8080e7          	jalr	-72(ra) # 8000011a <kalloc>
    8000116a:	892a                	mv	s2,a0
    8000116c:	eca8                	sd	a0,88(s1)
    8000116e:	c131                	beqz	a0,800011b2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001170:	8526                	mv	a0,s1
    80001172:	00000097          	auipc	ra,0x0
    80001176:	e5c080e7          	jalr	-420(ra) # 80000fce <proc_pagetable>
    8000117a:	892a                	mv	s2,a0
    8000117c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000117e:	c531                	beqz	a0,800011ca <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001180:	07000613          	li	a2,112
    80001184:	4581                	li	a1,0
    80001186:	06048513          	add	a0,s1,96
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	ff0080e7          	jalr	-16(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001192:	00000797          	auipc	a5,0x0
    80001196:	dac78793          	add	a5,a5,-596 # 80000f3e <forkret>
    8000119a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000119c:	60bc                	ld	a5,64(s1)
    8000119e:	6705                	lui	a4,0x1
    800011a0:	97ba                	add	a5,a5,a4
    800011a2:	f4bc                	sd	a5,104(s1)
}
    800011a4:	8526                	mv	a0,s1
    800011a6:	60e2                	ld	ra,24(sp)
    800011a8:	6442                	ld	s0,16(sp)
    800011aa:	64a2                	ld	s1,8(sp)
    800011ac:	6902                	ld	s2,0(sp)
    800011ae:	6105                	add	sp,sp,32
    800011b0:	8082                	ret
    freeproc(p);
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f08080e7          	jalr	-248(ra) # 800010bc <freeproc>
    release(&p->lock);
    800011bc:	8526                	mv	a0,s1
    800011be:	00005097          	auipc	ra,0x5
    800011c2:	202080e7          	jalr	514(ra) # 800063c0 <release>
    return 0;
    800011c6:	84ca                	mv	s1,s2
    800011c8:	bff1                	j	800011a4 <allocproc+0x90>
    freeproc(p);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	ef0080e7          	jalr	-272(ra) # 800010bc <freeproc>
    release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	1ea080e7          	jalr	490(ra) # 800063c0 <release>
    return 0;
    800011de:	84ca                	mv	s1,s2
    800011e0:	b7d1                	j	800011a4 <allocproc+0x90>

00000000800011e2 <userinit>:
{
    800011e2:	1101                	add	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	1000                	add	s0,sp,32
  p = allocproc();
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	f28080e7          	jalr	-216(ra) # 80001114 <allocproc>
    800011f4:	84aa                	mv	s1,a0
  initproc = p;
    800011f6:	00007797          	auipc	a5,0x7
    800011fa:	6ea7b523          	sd	a0,1770(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011fe:	03400613          	li	a2,52
    80001202:	00007597          	auipc	a1,0x7
    80001206:	68e58593          	add	a1,a1,1678 # 80008890 <initcode>
    8000120a:	6928                	ld	a0,80(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	61e080e7          	jalr	1566(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    80001214:	6785                	lui	a5,0x1
    80001216:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001218:	6cb8                	ld	a4,88(s1)
    8000121a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000121e:	6cb8                	ld	a4,88(s1)
    80001220:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001222:	4641                	li	a2,16
    80001224:	00007597          	auipc	a1,0x7
    80001228:	f9c58593          	add	a1,a1,-100 # 800081c0 <etext+0x1c0>
    8000122c:	15848513          	add	a0,s1,344
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	08c080e7          	jalr	140(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001238:	00007517          	auipc	a0,0x7
    8000123c:	f9850513          	add	a0,a0,-104 # 800081d0 <etext+0x1d0>
    80001240:	00002097          	auipc	ra,0x2
    80001244:	150080e7          	jalr	336(ra) # 80003390 <namei>
    80001248:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000124c:	478d                	li	a5,3
    8000124e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001250:	8526                	mv	a0,s1
    80001252:	00005097          	auipc	ra,0x5
    80001256:	16e080e7          	jalr	366(ra) # 800063c0 <release>
}
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6105                	add	sp,sp,32
    80001262:	8082                	ret

0000000080001264 <growproc>:
{
    80001264:	1101                	add	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	e04a                	sd	s2,0(sp)
    8000126e:	1000                	add	s0,sp,32
    80001270:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	c94080e7          	jalr	-876(ra) # 80000f06 <myproc>
    8000127a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000127c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000127e:	01204c63          	bgtz	s2,80001296 <growproc+0x32>
  } else if(n < 0){
    80001282:	02094663          	bltz	s2,800012ae <growproc+0x4a>
  p->sz = sz;
    80001286:	e4ac                	sd	a1,72(s1)
  return 0;
    80001288:	4501                	li	a0,0
}
    8000128a:	60e2                	ld	ra,24(sp)
    8000128c:	6442                	ld	s0,16(sp)
    8000128e:	64a2                	ld	s1,8(sp)
    80001290:	6902                	ld	s2,0(sp)
    80001292:	6105                	add	sp,sp,32
    80001294:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001296:	4691                	li	a3,4
    80001298:	00b90633          	add	a2,s2,a1
    8000129c:	6928                	ld	a0,80(a0)
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	646080e7          	jalr	1606(ra) # 800008e4 <uvmalloc>
    800012a6:	85aa                	mv	a1,a0
    800012a8:	fd79                	bnez	a0,80001286 <growproc+0x22>
      return -1;
    800012aa:	557d                	li	a0,-1
    800012ac:	bff9                	j	8000128a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ae:	00b90633          	add	a2,s2,a1
    800012b2:	6928                	ld	a0,80(a0)
    800012b4:	fffff097          	auipc	ra,0xfffff
    800012b8:	5e8080e7          	jalr	1512(ra) # 8000089c <uvmdealloc>
    800012bc:	85aa                	mv	a1,a0
    800012be:	b7e1                	j	80001286 <growproc+0x22>

00000000800012c0 <fork>:
{
    800012c0:	7139                	add	sp,sp,-64
    800012c2:	fc06                	sd	ra,56(sp)
    800012c4:	f822                	sd	s0,48(sp)
    800012c6:	f04a                	sd	s2,32(sp)
    800012c8:	e456                	sd	s5,8(sp)
    800012ca:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	c3a080e7          	jalr	-966(ra) # 80000f06 <myproc>
    800012d4:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	e3e080e7          	jalr	-450(ra) # 80001114 <allocproc>
    800012de:	12050063          	beqz	a0,800013fe <fork+0x13e>
    800012e2:	e852                	sd	s4,16(sp)
    800012e4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012e6:	048ab603          	ld	a2,72(s5)
    800012ea:	692c                	ld	a1,80(a0)
    800012ec:	050ab503          	ld	a0,80(s5)
    800012f0:	fffff097          	auipc	ra,0xfffff
    800012f4:	758080e7          	jalr	1880(ra) # 80000a48 <uvmcopy>
    800012f8:	04054a63          	bltz	a0,8000134c <fork+0x8c>
    800012fc:	f426                	sd	s1,40(sp)
    800012fe:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001300:	048ab783          	ld	a5,72(s5)
    80001304:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001308:	058ab683          	ld	a3,88(s5)
    8000130c:	87b6                	mv	a5,a3
    8000130e:	058a3703          	ld	a4,88(s4)
    80001312:	12068693          	add	a3,a3,288
    80001316:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000131a:	6788                	ld	a0,8(a5)
    8000131c:	6b8c                	ld	a1,16(a5)
    8000131e:	6f90                	ld	a2,24(a5)
    80001320:	01073023          	sd	a6,0(a4)
    80001324:	e708                	sd	a0,8(a4)
    80001326:	eb0c                	sd	a1,16(a4)
    80001328:	ef10                	sd	a2,24(a4)
    8000132a:	02078793          	add	a5,a5,32
    8000132e:	02070713          	add	a4,a4,32
    80001332:	fed792e3          	bne	a5,a3,80001316 <fork+0x56>
  np->trapframe->a0 = 0;
    80001336:	058a3783          	ld	a5,88(s4)
    8000133a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000133e:	0d0a8493          	add	s1,s5,208
    80001342:	0d0a0913          	add	s2,s4,208
    80001346:	150a8993          	add	s3,s5,336
    8000134a:	a015                	j	8000136e <fork+0xae>
    freeproc(np);
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	d6e080e7          	jalr	-658(ra) # 800010bc <freeproc>
    release(&np->lock);
    80001356:	8552                	mv	a0,s4
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	068080e7          	jalr	104(ra) # 800063c0 <release>
    return -1;
    80001360:	597d                	li	s2,-1
    80001362:	6a42                	ld	s4,16(sp)
    80001364:	a071                	j	800013f0 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001366:	04a1                	add	s1,s1,8
    80001368:	0921                	add	s2,s2,8
    8000136a:	01348b63          	beq	s1,s3,80001380 <fork+0xc0>
    if(p->ofile[i])
    8000136e:	6088                	ld	a0,0(s1)
    80001370:	d97d                	beqz	a0,80001366 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001372:	00002097          	auipc	ra,0x2
    80001376:	696080e7          	jalr	1686(ra) # 80003a08 <filedup>
    8000137a:	00a93023          	sd	a0,0(s2)
    8000137e:	b7e5                	j	80001366 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001380:	150ab503          	ld	a0,336(s5)
    80001384:	00002097          	auipc	ra,0x2
    80001388:	800080e7          	jalr	-2048(ra) # 80002b84 <idup>
    8000138c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001390:	4641                	li	a2,16
    80001392:	158a8593          	add	a1,s5,344
    80001396:	158a0513          	add	a0,s4,344
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	f22080e7          	jalr	-222(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800013a2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013a6:	8552                	mv	a0,s4
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	018080e7          	jalr	24(ra) # 800063c0 <release>
  acquire(&wait_lock);
    800013b0:	00007497          	auipc	s1,0x7
    800013b4:	58848493          	add	s1,s1,1416 # 80008938 <wait_lock>
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	f52080e7          	jalr	-174(ra) # 8000630c <acquire>
  np->parent = p;
    800013c2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	00005097          	auipc	ra,0x5
    800013cc:	ff8080e7          	jalr	-8(ra) # 800063c0 <release>
  acquire(&np->lock);
    800013d0:	8552                	mv	a0,s4
    800013d2:	00005097          	auipc	ra,0x5
    800013d6:	f3a080e7          	jalr	-198(ra) # 8000630c <acquire>
  np->state = RUNNABLE;
    800013da:	478d                	li	a5,3
    800013dc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013e0:	8552                	mv	a0,s4
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	fde080e7          	jalr	-34(ra) # 800063c0 <release>
  return pid;
    800013ea:	74a2                	ld	s1,40(sp)
    800013ec:	69e2                	ld	s3,24(sp)
    800013ee:	6a42                	ld	s4,16(sp)
}
    800013f0:	854a                	mv	a0,s2
    800013f2:	70e2                	ld	ra,56(sp)
    800013f4:	7442                	ld	s0,48(sp)
    800013f6:	7902                	ld	s2,32(sp)
    800013f8:	6aa2                	ld	s5,8(sp)
    800013fa:	6121                	add	sp,sp,64
    800013fc:	8082                	ret
    return -1;
    800013fe:	597d                	li	s2,-1
    80001400:	bfc5                	j	800013f0 <fork+0x130>

0000000080001402 <scheduler>:
{
    80001402:	7139                	add	sp,sp,-64
    80001404:	fc06                	sd	ra,56(sp)
    80001406:	f822                	sd	s0,48(sp)
    80001408:	f426                	sd	s1,40(sp)
    8000140a:	f04a                	sd	s2,32(sp)
    8000140c:	ec4e                	sd	s3,24(sp)
    8000140e:	e852                	sd	s4,16(sp)
    80001410:	e456                	sd	s5,8(sp)
    80001412:	e05a                	sd	s6,0(sp)
    80001414:	0080                	add	s0,sp,64
    80001416:	8792                	mv	a5,tp
  int id = r_tp();
    80001418:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000141a:	00779a93          	sll	s5,a5,0x7
    8000141e:	00007717          	auipc	a4,0x7
    80001422:	50270713          	add	a4,a4,1282 # 80008920 <pid_lock>
    80001426:	9756                	add	a4,a4,s5
    80001428:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000142c:	00007717          	auipc	a4,0x7
    80001430:	52c70713          	add	a4,a4,1324 # 80008958 <cpus+0x8>
    80001434:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001436:	498d                	li	s3,3
        p->state = RUNNING;
    80001438:	4b11                	li	s6,4
        c->proc = p;
    8000143a:	079e                	sll	a5,a5,0x7
    8000143c:	00007a17          	auipc	s4,0x7
    80001440:	4e4a0a13          	add	s4,s4,1252 # 80008920 <pid_lock>
    80001444:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001446:	0000d917          	auipc	s2,0xd
    8000144a:	30a90913          	add	s2,s2,778 # 8000e750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000144e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001452:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001456:	10079073          	csrw	sstatus,a5
    8000145a:	00008497          	auipc	s1,0x8
    8000145e:	8f648493          	add	s1,s1,-1802 # 80008d50 <proc>
    80001462:	a811                	j	80001476 <scheduler+0x74>
      release(&p->lock);
    80001464:	8526                	mv	a0,s1
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	f5a080e7          	jalr	-166(ra) # 800063c0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000146e:	16848493          	add	s1,s1,360
    80001472:	fd248ee3          	beq	s1,s2,8000144e <scheduler+0x4c>
      acquire(&p->lock);
    80001476:	8526                	mv	a0,s1
    80001478:	00005097          	auipc	ra,0x5
    8000147c:	e94080e7          	jalr	-364(ra) # 8000630c <acquire>
      if(p->state == RUNNABLE) {
    80001480:	4c9c                	lw	a5,24(s1)
    80001482:	ff3791e3          	bne	a5,s3,80001464 <scheduler+0x62>
        p->state = RUNNING;
    80001486:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000148a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000148e:	06048593          	add	a1,s1,96
    80001492:	8556                	mv	a0,s5
    80001494:	00000097          	auipc	ra,0x0
    80001498:	684080e7          	jalr	1668(ra) # 80001b18 <swtch>
        c->proc = 0;
    8000149c:	020a3823          	sd	zero,48(s4)
    800014a0:	b7d1                	j	80001464 <scheduler+0x62>

00000000800014a2 <sched>:
{
    800014a2:	7179                	add	sp,sp,-48
    800014a4:	f406                	sd	ra,40(sp)
    800014a6:	f022                	sd	s0,32(sp)
    800014a8:	ec26                	sd	s1,24(sp)
    800014aa:	e84a                	sd	s2,16(sp)
    800014ac:	e44e                	sd	s3,8(sp)
    800014ae:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	a56080e7          	jalr	-1450(ra) # 80000f06 <myproc>
    800014b8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	dd8080e7          	jalr	-552(ra) # 80006292 <holding>
    800014c2:	c93d                	beqz	a0,80001538 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014c4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	sll	a5,a5,0x7
    800014ca:	00007717          	auipc	a4,0x7
    800014ce:	45670713          	add	a4,a4,1110 # 80008920 <pid_lock>
    800014d2:	97ba                	add	a5,a5,a4
    800014d4:	0a87a703          	lw	a4,168(a5)
    800014d8:	4785                	li	a5,1
    800014da:	06f71763          	bne	a4,a5,80001548 <sched+0xa6>
  if(p->state == RUNNING)
    800014de:	4c98                	lw	a4,24(s1)
    800014e0:	4791                	li	a5,4
    800014e2:	06f70b63          	beq	a4,a5,80001558 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ea:	8b89                	and	a5,a5,2
  if(intr_get())
    800014ec:	efb5                	bnez	a5,80001568 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014f0:	00007917          	auipc	s2,0x7
    800014f4:	43090913          	add	s2,s2,1072 # 80008920 <pid_lock>
    800014f8:	2781                	sext.w	a5,a5
    800014fa:	079e                	sll	a5,a5,0x7
    800014fc:	97ca                	add	a5,a5,s2
    800014fe:	0ac7a983          	lw	s3,172(a5)
    80001502:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	sll	a5,a5,0x7
    80001508:	00007597          	auipc	a1,0x7
    8000150c:	45058593          	add	a1,a1,1104 # 80008958 <cpus+0x8>
    80001510:	95be                	add	a1,a1,a5
    80001512:	06048513          	add	a0,s1,96
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	602080e7          	jalr	1538(ra) # 80001b18 <swtch>
    8000151e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001520:	2781                	sext.w	a5,a5
    80001522:	079e                	sll	a5,a5,0x7
    80001524:	993e                	add	s2,s2,a5
    80001526:	0b392623          	sw	s3,172(s2)
}
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6145                	add	sp,sp,48
    80001536:	8082                	ret
    panic("sched p->lock");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	ca050513          	add	a0,a0,-864 # 800081d8 <etext+0x1d8>
    80001540:	00005097          	auipc	ra,0x5
    80001544:	852080e7          	jalr	-1966(ra) # 80005d92 <panic>
    panic("sched locks");
    80001548:	00007517          	auipc	a0,0x7
    8000154c:	ca050513          	add	a0,a0,-864 # 800081e8 <etext+0x1e8>
    80001550:	00005097          	auipc	ra,0x5
    80001554:	842080e7          	jalr	-1982(ra) # 80005d92 <panic>
    panic("sched running");
    80001558:	00007517          	auipc	a0,0x7
    8000155c:	ca050513          	add	a0,a0,-864 # 800081f8 <etext+0x1f8>
    80001560:	00005097          	auipc	ra,0x5
    80001564:	832080e7          	jalr	-1998(ra) # 80005d92 <panic>
    panic("sched interruptible");
    80001568:	00007517          	auipc	a0,0x7
    8000156c:	ca050513          	add	a0,a0,-864 # 80008208 <etext+0x208>
    80001570:	00005097          	auipc	ra,0x5
    80001574:	822080e7          	jalr	-2014(ra) # 80005d92 <panic>

0000000080001578 <yield>:
{
    80001578:	1101                	add	sp,sp,-32
    8000157a:	ec06                	sd	ra,24(sp)
    8000157c:	e822                	sd	s0,16(sp)
    8000157e:	e426                	sd	s1,8(sp)
    80001580:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	984080e7          	jalr	-1660(ra) # 80000f06 <myproc>
    8000158a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	d80080e7          	jalr	-640(ra) # 8000630c <acquire>
  p->state = RUNNABLE;
    80001594:	478d                	li	a5,3
    80001596:	cc9c                	sw	a5,24(s1)
  sched();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	f0a080e7          	jalr	-246(ra) # 800014a2 <sched>
  release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	e1e080e7          	jalr	-482(ra) # 800063c0 <release>
}
    800015aa:	60e2                	ld	ra,24(sp)
    800015ac:	6442                	ld	s0,16(sp)
    800015ae:	64a2                	ld	s1,8(sp)
    800015b0:	6105                	add	sp,sp,32
    800015b2:	8082                	ret

00000000800015b4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015b4:	7179                	add	sp,sp,-48
    800015b6:	f406                	sd	ra,40(sp)
    800015b8:	f022                	sd	s0,32(sp)
    800015ba:	ec26                	sd	s1,24(sp)
    800015bc:	e84a                	sd	s2,16(sp)
    800015be:	e44e                	sd	s3,8(sp)
    800015c0:	1800                	add	s0,sp,48
    800015c2:	89aa                	mv	s3,a0
    800015c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	940080e7          	jalr	-1728(ra) # 80000f06 <myproc>
    800015ce:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	d3c080e7          	jalr	-708(ra) # 8000630c <acquire>
  release(lk);
    800015d8:	854a                	mv	a0,s2
    800015da:	00005097          	auipc	ra,0x5
    800015de:	de6080e7          	jalr	-538(ra) # 800063c0 <release>

  // Go to sleep.
  p->chan = chan;
    800015e2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015e6:	4789                	li	a5,2
    800015e8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	eb8080e7          	jalr	-328(ra) # 800014a2 <sched>

  // Tidy up.
  p->chan = 0;
    800015f2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	dc8080e7          	jalr	-568(ra) # 800063c0 <release>
  acquire(lk);
    80001600:	854a                	mv	a0,s2
    80001602:	00005097          	auipc	ra,0x5
    80001606:	d0a080e7          	jalr	-758(ra) # 8000630c <acquire>
}
    8000160a:	70a2                	ld	ra,40(sp)
    8000160c:	7402                	ld	s0,32(sp)
    8000160e:	64e2                	ld	s1,24(sp)
    80001610:	6942                	ld	s2,16(sp)
    80001612:	69a2                	ld	s3,8(sp)
    80001614:	6145                	add	sp,sp,48
    80001616:	8082                	ret

0000000080001618 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001618:	7139                	add	sp,sp,-64
    8000161a:	fc06                	sd	ra,56(sp)
    8000161c:	f822                	sd	s0,48(sp)
    8000161e:	f426                	sd	s1,40(sp)
    80001620:	f04a                	sd	s2,32(sp)
    80001622:	ec4e                	sd	s3,24(sp)
    80001624:	e852                	sd	s4,16(sp)
    80001626:	e456                	sd	s5,8(sp)
    80001628:	0080                	add	s0,sp,64
    8000162a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000162c:	00007497          	auipc	s1,0x7
    80001630:	72448493          	add	s1,s1,1828 # 80008d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001634:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001636:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001638:	0000d917          	auipc	s2,0xd
    8000163c:	11890913          	add	s2,s2,280 # 8000e750 <tickslock>
    80001640:	a811                	j	80001654 <wakeup+0x3c>
      }
      release(&p->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	d7c080e7          	jalr	-644(ra) # 800063c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000164c:	16848493          	add	s1,s1,360
    80001650:	03248663          	beq	s1,s2,8000167c <wakeup+0x64>
    if(p != myproc()){
    80001654:	00000097          	auipc	ra,0x0
    80001658:	8b2080e7          	jalr	-1870(ra) # 80000f06 <myproc>
    8000165c:	fea488e3          	beq	s1,a0,8000164c <wakeup+0x34>
      acquire(&p->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	caa080e7          	jalr	-854(ra) # 8000630c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000166a:	4c9c                	lw	a5,24(s1)
    8000166c:	fd379be3          	bne	a5,s3,80001642 <wakeup+0x2a>
    80001670:	709c                	ld	a5,32(s1)
    80001672:	fd4798e3          	bne	a5,s4,80001642 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001676:	0154ac23          	sw	s5,24(s1)
    8000167a:	b7e1                	j	80001642 <wakeup+0x2a>
    }
  }
}
    8000167c:	70e2                	ld	ra,56(sp)
    8000167e:	7442                	ld	s0,48(sp)
    80001680:	74a2                	ld	s1,40(sp)
    80001682:	7902                	ld	s2,32(sp)
    80001684:	69e2                	ld	s3,24(sp)
    80001686:	6a42                	ld	s4,16(sp)
    80001688:	6aa2                	ld	s5,8(sp)
    8000168a:	6121                	add	sp,sp,64
    8000168c:	8082                	ret

000000008000168e <reparent>:
{
    8000168e:	7179                	add	sp,sp,-48
    80001690:	f406                	sd	ra,40(sp)
    80001692:	f022                	sd	s0,32(sp)
    80001694:	ec26                	sd	s1,24(sp)
    80001696:	e84a                	sd	s2,16(sp)
    80001698:	e44e                	sd	s3,8(sp)
    8000169a:	e052                	sd	s4,0(sp)
    8000169c:	1800                	add	s0,sp,48
    8000169e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a0:	00007497          	auipc	s1,0x7
    800016a4:	6b048493          	add	s1,s1,1712 # 80008d50 <proc>
      pp->parent = initproc;
    800016a8:	00007a17          	auipc	s4,0x7
    800016ac:	238a0a13          	add	s4,s4,568 # 800088e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b0:	0000d997          	auipc	s3,0xd
    800016b4:	0a098993          	add	s3,s3,160 # 8000e750 <tickslock>
    800016b8:	a029                	j	800016c2 <reparent+0x34>
    800016ba:	16848493          	add	s1,s1,360
    800016be:	01348d63          	beq	s1,s3,800016d8 <reparent+0x4a>
    if(pp->parent == p){
    800016c2:	7c9c                	ld	a5,56(s1)
    800016c4:	ff279be3          	bne	a5,s2,800016ba <reparent+0x2c>
      pp->parent = initproc;
    800016c8:	000a3503          	ld	a0,0(s4)
    800016cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	f4a080e7          	jalr	-182(ra) # 80001618 <wakeup>
    800016d6:	b7d5                	j	800016ba <reparent+0x2c>
}
    800016d8:	70a2                	ld	ra,40(sp)
    800016da:	7402                	ld	s0,32(sp)
    800016dc:	64e2                	ld	s1,24(sp)
    800016de:	6942                	ld	s2,16(sp)
    800016e0:	69a2                	ld	s3,8(sp)
    800016e2:	6a02                	ld	s4,0(sp)
    800016e4:	6145                	add	sp,sp,48
    800016e6:	8082                	ret

00000000800016e8 <exit>:
{
    800016e8:	7179                	add	sp,sp,-48
    800016ea:	f406                	sd	ra,40(sp)
    800016ec:	f022                	sd	s0,32(sp)
    800016ee:	ec26                	sd	s1,24(sp)
    800016f0:	e84a                	sd	s2,16(sp)
    800016f2:	e44e                	sd	s3,8(sp)
    800016f4:	e052                	sd	s4,0(sp)
    800016f6:	1800                	add	s0,sp,48
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	80c080e7          	jalr	-2036(ra) # 80000f06 <myproc>
    80001702:	89aa                	mv	s3,a0
  if(p == initproc)
    80001704:	00007797          	auipc	a5,0x7
    80001708:	1dc7b783          	ld	a5,476(a5) # 800088e0 <initproc>
    8000170c:	0d050493          	add	s1,a0,208
    80001710:	15050913          	add	s2,a0,336
    80001714:	02a79363          	bne	a5,a0,8000173a <exit+0x52>
    panic("init exiting");
    80001718:	00007517          	auipc	a0,0x7
    8000171c:	b0850513          	add	a0,a0,-1272 # 80008220 <etext+0x220>
    80001720:	00004097          	auipc	ra,0x4
    80001724:	672080e7          	jalr	1650(ra) # 80005d92 <panic>
      fileclose(f);
    80001728:	00002097          	auipc	ra,0x2
    8000172c:	332080e7          	jalr	818(ra) # 80003a5a <fileclose>
      p->ofile[fd] = 0;
    80001730:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001734:	04a1                	add	s1,s1,8
    80001736:	01248563          	beq	s1,s2,80001740 <exit+0x58>
    if(p->ofile[fd]){
    8000173a:	6088                	ld	a0,0(s1)
    8000173c:	f575                	bnez	a0,80001728 <exit+0x40>
    8000173e:	bfdd                	j	80001734 <exit+0x4c>
  begin_op();
    80001740:	00002097          	auipc	ra,0x2
    80001744:	e50080e7          	jalr	-432(ra) # 80003590 <begin_op>
  iput(p->cwd);
    80001748:	1509b503          	ld	a0,336(s3)
    8000174c:	00001097          	auipc	ra,0x1
    80001750:	634080e7          	jalr	1588(ra) # 80002d80 <iput>
  end_op();
    80001754:	00002097          	auipc	ra,0x2
    80001758:	eb6080e7          	jalr	-330(ra) # 8000360a <end_op>
  p->cwd = 0;
    8000175c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001760:	00007497          	auipc	s1,0x7
    80001764:	1d848493          	add	s1,s1,472 # 80008938 <wait_lock>
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	ba2080e7          	jalr	-1118(ra) # 8000630c <acquire>
  reparent(p);
    80001772:	854e                	mv	a0,s3
    80001774:	00000097          	auipc	ra,0x0
    80001778:	f1a080e7          	jalr	-230(ra) # 8000168e <reparent>
  wakeup(p->parent);
    8000177c:	0389b503          	ld	a0,56(s3)
    80001780:	00000097          	auipc	ra,0x0
    80001784:	e98080e7          	jalr	-360(ra) # 80001618 <wakeup>
  acquire(&p->lock);
    80001788:	854e                	mv	a0,s3
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	b82080e7          	jalr	-1150(ra) # 8000630c <acquire>
  p->xstate = status;
    80001792:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001796:	4795                	li	a5,5
    80001798:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	c22080e7          	jalr	-990(ra) # 800063c0 <release>
  sched();
    800017a6:	00000097          	auipc	ra,0x0
    800017aa:	cfc080e7          	jalr	-772(ra) # 800014a2 <sched>
  panic("zombie exit");
    800017ae:	00007517          	auipc	a0,0x7
    800017b2:	a8250513          	add	a0,a0,-1406 # 80008230 <etext+0x230>
    800017b6:	00004097          	auipc	ra,0x4
    800017ba:	5dc080e7          	jalr	1500(ra) # 80005d92 <panic>

00000000800017be <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800017be:	7179                	add	sp,sp,-48
    800017c0:	f406                	sd	ra,40(sp)
    800017c2:	f022                	sd	s0,32(sp)
    800017c4:	ec26                	sd	s1,24(sp)
    800017c6:	e84a                	sd	s2,16(sp)
    800017c8:	e44e                	sd	s3,8(sp)
    800017ca:	1800                	add	s0,sp,48
    800017cc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017ce:	00007497          	auipc	s1,0x7
    800017d2:	58248493          	add	s1,s1,1410 # 80008d50 <proc>
    800017d6:	0000d997          	auipc	s3,0xd
    800017da:	f7a98993          	add	s3,s3,-134 # 8000e750 <tickslock>
    acquire(&p->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	b2c080e7          	jalr	-1236(ra) # 8000630c <acquire>
    if(p->pid == pid){
    800017e8:	589c                	lw	a5,48(s1)
    800017ea:	01278d63          	beq	a5,s2,80001804 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	bd0080e7          	jalr	-1072(ra) # 800063c0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017f8:	16848493          	add	s1,s1,360
    800017fc:	ff3491e3          	bne	s1,s3,800017de <kill+0x20>
  }
  return -1;
    80001800:	557d                	li	a0,-1
    80001802:	a829                	j	8000181c <kill+0x5e>
      p->killed = 1;
    80001804:	4785                	li	a5,1
    80001806:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001808:	4c98                	lw	a4,24(s1)
    8000180a:	4789                	li	a5,2
    8000180c:	00f70f63          	beq	a4,a5,8000182a <kill+0x6c>
      release(&p->lock);
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	bae080e7          	jalr	-1106(ra) # 800063c0 <release>
      return 0;
    8000181a:	4501                	li	a0,0
}
    8000181c:	70a2                	ld	ra,40(sp)
    8000181e:	7402                	ld	s0,32(sp)
    80001820:	64e2                	ld	s1,24(sp)
    80001822:	6942                	ld	s2,16(sp)
    80001824:	69a2                	ld	s3,8(sp)
    80001826:	6145                	add	sp,sp,48
    80001828:	8082                	ret
        p->state = RUNNABLE;
    8000182a:	478d                	li	a5,3
    8000182c:	cc9c                	sw	a5,24(s1)
    8000182e:	b7cd                	j	80001810 <kill+0x52>

0000000080001830 <setkilled>:

void
setkilled(struct proc *p)
{
    80001830:	1101                	add	sp,sp,-32
    80001832:	ec06                	sd	ra,24(sp)
    80001834:	e822                	sd	s0,16(sp)
    80001836:	e426                	sd	s1,8(sp)
    80001838:	1000                	add	s0,sp,32
    8000183a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	ad0080e7          	jalr	-1328(ra) # 8000630c <acquire>
  p->killed = 1;
    80001844:	4785                	li	a5,1
    80001846:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001848:	8526                	mv	a0,s1
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	b76080e7          	jalr	-1162(ra) # 800063c0 <release>
}
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6105                	add	sp,sp,32
    8000185a:	8082                	ret

000000008000185c <killed>:

int
killed(struct proc *p)
{
    8000185c:	1101                	add	sp,sp,-32
    8000185e:	ec06                	sd	ra,24(sp)
    80001860:	e822                	sd	s0,16(sp)
    80001862:	e426                	sd	s1,8(sp)
    80001864:	e04a                	sd	s2,0(sp)
    80001866:	1000                	add	s0,sp,32
    80001868:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	aa2080e7          	jalr	-1374(ra) # 8000630c <acquire>
  k = p->killed;
    80001872:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	b48080e7          	jalr	-1208(ra) # 800063c0 <release>
  return k;
}
    80001880:	854a                	mv	a0,s2
    80001882:	60e2                	ld	ra,24(sp)
    80001884:	6442                	ld	s0,16(sp)
    80001886:	64a2                	ld	s1,8(sp)
    80001888:	6902                	ld	s2,0(sp)
    8000188a:	6105                	add	sp,sp,32
    8000188c:	8082                	ret

000000008000188e <wait>:
{
    8000188e:	715d                	add	sp,sp,-80
    80001890:	e486                	sd	ra,72(sp)
    80001892:	e0a2                	sd	s0,64(sp)
    80001894:	fc26                	sd	s1,56(sp)
    80001896:	f84a                	sd	s2,48(sp)
    80001898:	f44e                	sd	s3,40(sp)
    8000189a:	f052                	sd	s4,32(sp)
    8000189c:	ec56                	sd	s5,24(sp)
    8000189e:	e85a                	sd	s6,16(sp)
    800018a0:	e45e                	sd	s7,8(sp)
    800018a2:	e062                	sd	s8,0(sp)
    800018a4:	0880                	add	s0,sp,80
    800018a6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018a8:	fffff097          	auipc	ra,0xfffff
    800018ac:	65e080e7          	jalr	1630(ra) # 80000f06 <myproc>
    800018b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018b2:	00007517          	auipc	a0,0x7
    800018b6:	08650513          	add	a0,a0,134 # 80008938 <wait_lock>
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	a52080e7          	jalr	-1454(ra) # 8000630c <acquire>
    havekids = 0;
    800018c2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018c4:	4a15                	li	s4,5
        havekids = 1;
    800018c6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c8:	0000d997          	auipc	s3,0xd
    800018cc:	e8898993          	add	s3,s3,-376 # 8000e750 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018d0:	00007c17          	auipc	s8,0x7
    800018d4:	068c0c13          	add	s8,s8,104 # 80008938 <wait_lock>
    800018d8:	a0d1                	j	8000199c <wait+0x10e>
          pid = pp->pid;
    800018da:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018de:	000b0e63          	beqz	s6,800018fa <wait+0x6c>
    800018e2:	4691                	li	a3,4
    800018e4:	02c48613          	add	a2,s1,44
    800018e8:	85da                	mv	a1,s6
    800018ea:	05093503          	ld	a0,80(s2)
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	25e080e7          	jalr	606(ra) # 80000b4c <copyout>
    800018f6:	04054163          	bltz	a0,80001938 <wait+0xaa>
          freeproc(pp);
    800018fa:	8526                	mv	a0,s1
    800018fc:	fffff097          	auipc	ra,0xfffff
    80001900:	7c0080e7          	jalr	1984(ra) # 800010bc <freeproc>
          release(&pp->lock);
    80001904:	8526                	mv	a0,s1
    80001906:	00005097          	auipc	ra,0x5
    8000190a:	aba080e7          	jalr	-1350(ra) # 800063c0 <release>
          release(&wait_lock);
    8000190e:	00007517          	auipc	a0,0x7
    80001912:	02a50513          	add	a0,a0,42 # 80008938 <wait_lock>
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	aaa080e7          	jalr	-1366(ra) # 800063c0 <release>
}
    8000191e:	854e                	mv	a0,s3
    80001920:	60a6                	ld	ra,72(sp)
    80001922:	6406                	ld	s0,64(sp)
    80001924:	74e2                	ld	s1,56(sp)
    80001926:	7942                	ld	s2,48(sp)
    80001928:	79a2                	ld	s3,40(sp)
    8000192a:	7a02                	ld	s4,32(sp)
    8000192c:	6ae2                	ld	s5,24(sp)
    8000192e:	6b42                	ld	s6,16(sp)
    80001930:	6ba2                	ld	s7,8(sp)
    80001932:	6c02                	ld	s8,0(sp)
    80001934:	6161                	add	sp,sp,80
    80001936:	8082                	ret
            release(&pp->lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	a86080e7          	jalr	-1402(ra) # 800063c0 <release>
            release(&wait_lock);
    80001942:	00007517          	auipc	a0,0x7
    80001946:	ff650513          	add	a0,a0,-10 # 80008938 <wait_lock>
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	a76080e7          	jalr	-1418(ra) # 800063c0 <release>
            return -1;
    80001952:	59fd                	li	s3,-1
    80001954:	b7e9                	j	8000191e <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001956:	16848493          	add	s1,s1,360
    8000195a:	03348463          	beq	s1,s3,80001982 <wait+0xf4>
      if(pp->parent == p){
    8000195e:	7c9c                	ld	a5,56(s1)
    80001960:	ff279be3          	bne	a5,s2,80001956 <wait+0xc8>
        acquire(&pp->lock);
    80001964:	8526                	mv	a0,s1
    80001966:	00005097          	auipc	ra,0x5
    8000196a:	9a6080e7          	jalr	-1626(ra) # 8000630c <acquire>
        if(pp->state == ZOMBIE){
    8000196e:	4c9c                	lw	a5,24(s1)
    80001970:	f74785e3          	beq	a5,s4,800018da <wait+0x4c>
        release(&pp->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	a4a080e7          	jalr	-1462(ra) # 800063c0 <release>
        havekids = 1;
    8000197e:	8756                	mv	a4,s5
    80001980:	bfd9                	j	80001956 <wait+0xc8>
    if(!havekids || killed(p)){
    80001982:	c31d                	beqz	a4,800019a8 <wait+0x11a>
    80001984:	854a                	mv	a0,s2
    80001986:	00000097          	auipc	ra,0x0
    8000198a:	ed6080e7          	jalr	-298(ra) # 8000185c <killed>
    8000198e:	ed09                	bnez	a0,800019a8 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001990:	85e2                	mv	a1,s8
    80001992:	854a                	mv	a0,s2
    80001994:	00000097          	auipc	ra,0x0
    80001998:	c20080e7          	jalr	-992(ra) # 800015b4 <sleep>
    havekids = 0;
    8000199c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000199e:	00007497          	auipc	s1,0x7
    800019a2:	3b248493          	add	s1,s1,946 # 80008d50 <proc>
    800019a6:	bf65                	j	8000195e <wait+0xd0>
      release(&wait_lock);
    800019a8:	00007517          	auipc	a0,0x7
    800019ac:	f9050513          	add	a0,a0,-112 # 80008938 <wait_lock>
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	a10080e7          	jalr	-1520(ra) # 800063c0 <release>
      return -1;
    800019b8:	59fd                	li	s3,-1
    800019ba:	b795                	j	8000191e <wait+0x90>

00000000800019bc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019bc:	7179                	add	sp,sp,-48
    800019be:	f406                	sd	ra,40(sp)
    800019c0:	f022                	sd	s0,32(sp)
    800019c2:	ec26                	sd	s1,24(sp)
    800019c4:	e84a                	sd	s2,16(sp)
    800019c6:	e44e                	sd	s3,8(sp)
    800019c8:	e052                	sd	s4,0(sp)
    800019ca:	1800                	add	s0,sp,48
    800019cc:	84aa                	mv	s1,a0
    800019ce:	892e                	mv	s2,a1
    800019d0:	89b2                	mv	s3,a2
    800019d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	532080e7          	jalr	1330(ra) # 80000f06 <myproc>
  if(user_dst){
    800019dc:	c08d                	beqz	s1,800019fe <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019de:	86d2                	mv	a3,s4
    800019e0:	864e                	mv	a2,s3
    800019e2:	85ca                	mv	a1,s2
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	166080e7          	jalr	358(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019ee:	70a2                	ld	ra,40(sp)
    800019f0:	7402                	ld	s0,32(sp)
    800019f2:	64e2                	ld	s1,24(sp)
    800019f4:	6942                	ld	s2,16(sp)
    800019f6:	69a2                	ld	s3,8(sp)
    800019f8:	6a02                	ld	s4,0(sp)
    800019fa:	6145                	add	sp,sp,48
    800019fc:	8082                	ret
    memmove((char *)dst, src, len);
    800019fe:	000a061b          	sext.w	a2,s4
    80001a02:	85ce                	mv	a1,s3
    80001a04:	854a                	mv	a0,s2
    80001a06:	ffffe097          	auipc	ra,0xffffe
    80001a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
    return 0;
    80001a0e:	8526                	mv	a0,s1
    80001a10:	bff9                	j	800019ee <either_copyout+0x32>

0000000080001a12 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a12:	7179                	add	sp,sp,-48
    80001a14:	f406                	sd	ra,40(sp)
    80001a16:	f022                	sd	s0,32(sp)
    80001a18:	ec26                	sd	s1,24(sp)
    80001a1a:	e84a                	sd	s2,16(sp)
    80001a1c:	e44e                	sd	s3,8(sp)
    80001a1e:	e052                	sd	s4,0(sp)
    80001a20:	1800                	add	s0,sp,48
    80001a22:	892a                	mv	s2,a0
    80001a24:	84ae                	mv	s1,a1
    80001a26:	89b2                	mv	s3,a2
    80001a28:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	4dc080e7          	jalr	1244(ra) # 80000f06 <myproc>
  if(user_src){
    80001a32:	c08d                	beqz	s1,80001a54 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a34:	86d2                	mv	a3,s4
    80001a36:	864e                	mv	a2,s3
    80001a38:	85ca                	mv	a1,s2
    80001a3a:	6928                	ld	a0,80(a0)
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	1ee080e7          	jalr	494(ra) # 80000c2a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a44:	70a2                	ld	ra,40(sp)
    80001a46:	7402                	ld	s0,32(sp)
    80001a48:	64e2                	ld	s1,24(sp)
    80001a4a:	6942                	ld	s2,16(sp)
    80001a4c:	69a2                	ld	s3,8(sp)
    80001a4e:	6a02                	ld	s4,0(sp)
    80001a50:	6145                	add	sp,sp,48
    80001a52:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a54:	000a061b          	sext.w	a2,s4
    80001a58:	85ce                	mv	a1,s3
    80001a5a:	854a                	mv	a0,s2
    80001a5c:	ffffe097          	auipc	ra,0xffffe
    80001a60:	77a080e7          	jalr	1914(ra) # 800001d6 <memmove>
    return 0;
    80001a64:	8526                	mv	a0,s1
    80001a66:	bff9                	j	80001a44 <either_copyin+0x32>

0000000080001a68 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a68:	715d                	add	sp,sp,-80
    80001a6a:	e486                	sd	ra,72(sp)
    80001a6c:	e0a2                	sd	s0,64(sp)
    80001a6e:	fc26                	sd	s1,56(sp)
    80001a70:	f84a                	sd	s2,48(sp)
    80001a72:	f44e                	sd	s3,40(sp)
    80001a74:	f052                	sd	s4,32(sp)
    80001a76:	ec56                	sd	s5,24(sp)
    80001a78:	e85a                	sd	s6,16(sp)
    80001a7a:	e45e                	sd	s7,8(sp)
    80001a7c:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a7e:	00006517          	auipc	a0,0x6
    80001a82:	59a50513          	add	a0,a0,1434 # 80008018 <etext+0x18>
    80001a86:	00004097          	auipc	ra,0x4
    80001a8a:	356080e7          	jalr	854(ra) # 80005ddc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a8e:	00007497          	auipc	s1,0x7
    80001a92:	41a48493          	add	s1,s1,1050 # 80008ea8 <proc+0x158>
    80001a96:	0000d917          	auipc	s2,0xd
    80001a9a:	e1290913          	add	s2,s2,-494 # 8000e8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a9e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa0:	00006997          	auipc	s3,0x6
    80001aa4:	7a098993          	add	s3,s3,1952 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001aa8:	00006a97          	auipc	s5,0x6
    80001aac:	7a0a8a93          	add	s5,s5,1952 # 80008248 <etext+0x248>
    printf("\n");
    80001ab0:	00006a17          	auipc	s4,0x6
    80001ab4:	568a0a13          	add	s4,s4,1384 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab8:	00007b97          	auipc	s7,0x7
    80001abc:	cb8b8b93          	add	s7,s7,-840 # 80008770 <states.0>
    80001ac0:	a00d                	j	80001ae2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac2:	ed86a583          	lw	a1,-296(a3)
    80001ac6:	8556                	mv	a0,s5
    80001ac8:	00004097          	auipc	ra,0x4
    80001acc:	314080e7          	jalr	788(ra) # 80005ddc <printf>
    printf("\n");
    80001ad0:	8552                	mv	a0,s4
    80001ad2:	00004097          	auipc	ra,0x4
    80001ad6:	30a080e7          	jalr	778(ra) # 80005ddc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ada:	16848493          	add	s1,s1,360
    80001ade:	03248263          	beq	s1,s2,80001b02 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ae2:	86a6                	mv	a3,s1
    80001ae4:	ec04a783          	lw	a5,-320(s1)
    80001ae8:	dbed                	beqz	a5,80001ada <procdump+0x72>
      state = "???";
    80001aea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aec:	fcfb6be3          	bltu	s6,a5,80001ac2 <procdump+0x5a>
    80001af0:	02079713          	sll	a4,a5,0x20
    80001af4:	01d75793          	srl	a5,a4,0x1d
    80001af8:	97de                	add	a5,a5,s7
    80001afa:	6390                	ld	a2,0(a5)
    80001afc:	f279                	bnez	a2,80001ac2 <procdump+0x5a>
      state = "???";
    80001afe:	864e                	mv	a2,s3
    80001b00:	b7c9                	j	80001ac2 <procdump+0x5a>
  }
}
    80001b02:	60a6                	ld	ra,72(sp)
    80001b04:	6406                	ld	s0,64(sp)
    80001b06:	74e2                	ld	s1,56(sp)
    80001b08:	7942                	ld	s2,48(sp)
    80001b0a:	79a2                	ld	s3,40(sp)
    80001b0c:	7a02                	ld	s4,32(sp)
    80001b0e:	6ae2                	ld	s5,24(sp)
    80001b10:	6b42                	ld	s6,16(sp)
    80001b12:	6ba2                	ld	s7,8(sp)
    80001b14:	6161                	add	sp,sp,80
    80001b16:	8082                	ret

0000000080001b18 <swtch>:
    80001b18:	00153023          	sd	ra,0(a0)
    80001b1c:	00253423          	sd	sp,8(a0)
    80001b20:	e900                	sd	s0,16(a0)
    80001b22:	ed04                	sd	s1,24(a0)
    80001b24:	03253023          	sd	s2,32(a0)
    80001b28:	03353423          	sd	s3,40(a0)
    80001b2c:	03453823          	sd	s4,48(a0)
    80001b30:	03553c23          	sd	s5,56(a0)
    80001b34:	05653023          	sd	s6,64(a0)
    80001b38:	05753423          	sd	s7,72(a0)
    80001b3c:	05853823          	sd	s8,80(a0)
    80001b40:	05953c23          	sd	s9,88(a0)
    80001b44:	07a53023          	sd	s10,96(a0)
    80001b48:	07b53423          	sd	s11,104(a0)
    80001b4c:	0005b083          	ld	ra,0(a1)
    80001b50:	0085b103          	ld	sp,8(a1)
    80001b54:	6980                	ld	s0,16(a1)
    80001b56:	6d84                	ld	s1,24(a1)
    80001b58:	0205b903          	ld	s2,32(a1)
    80001b5c:	0285b983          	ld	s3,40(a1)
    80001b60:	0305ba03          	ld	s4,48(a1)
    80001b64:	0385ba83          	ld	s5,56(a1)
    80001b68:	0405bb03          	ld	s6,64(a1)
    80001b6c:	0485bb83          	ld	s7,72(a1)
    80001b70:	0505bc03          	ld	s8,80(a1)
    80001b74:	0585bc83          	ld	s9,88(a1)
    80001b78:	0605bd03          	ld	s10,96(a1)
    80001b7c:	0685bd83          	ld	s11,104(a1)
    80001b80:	8082                	ret

0000000080001b82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b82:	1141                	add	sp,sp,-16
    80001b84:	e406                	sd	ra,8(sp)
    80001b86:	e022                	sd	s0,0(sp)
    80001b88:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b8a:	00006597          	auipc	a1,0x6
    80001b8e:	6fe58593          	add	a1,a1,1790 # 80008288 <etext+0x288>
    80001b92:	0000d517          	auipc	a0,0xd
    80001b96:	bbe50513          	add	a0,a0,-1090 # 8000e750 <tickslock>
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	6e2080e7          	jalr	1762(ra) # 8000627c <initlock>
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	add	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001baa:	1141                	add	sp,sp,-16
    80001bac:	e422                	sd	s0,8(sp)
    80001bae:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb0:	00003797          	auipc	a5,0x3
    80001bb4:	5b078793          	add	a5,a5,1456 # 80005160 <kernelvec>
    80001bb8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bbc:	6422                	ld	s0,8(sp)
    80001bbe:	0141                	add	sp,sp,16
    80001bc0:	8082                	ret

0000000080001bc2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc2:	1141                	add	sp,sp,-16
    80001bc4:	e406                	sd	ra,8(sp)
    80001bc6:	e022                	sd	s0,0(sp)
    80001bc8:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	33c080e7          	jalr	828(ra) # 80000f06 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd6:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bdc:	00005697          	auipc	a3,0x5
    80001be0:	42468693          	add	a3,a3,1060 # 80007000 <_trampoline>
    80001be4:	00005717          	auipc	a4,0x5
    80001be8:	41c70713          	add	a4,a4,1052 # 80007000 <_trampoline>
    80001bec:	8f15                	sub	a4,a4,a3
    80001bee:	040007b7          	lui	a5,0x4000
    80001bf2:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bf4:	07b2                	sll	a5,a5,0xc
    80001bf6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bfe:	18002673          	csrr	a2,satp
    80001c02:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c04:	6d30                	ld	a2,88(a0)
    80001c06:	6138                	ld	a4,64(a0)
    80001c08:	6585                	lui	a1,0x1
    80001c0a:	972e                	add	a4,a4,a1
    80001c0c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c0e:	6d38                	ld	a4,88(a0)
    80001c10:	00000617          	auipc	a2,0x0
    80001c14:	13860613          	add	a2,a2,312 # 80001d48 <usertrap>
    80001c18:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1c:	8612                	mv	a2,tp
    80001c1e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c20:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c24:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c28:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c2c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c32:	6f18                	ld	a4,24(a4)
    80001c34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c38:	6928                	ld	a0,80(a0)
    80001c3a:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c3c:	00005717          	auipc	a4,0x5
    80001c40:	46070713          	add	a4,a4,1120 # 8000709c <userret>
    80001c44:	8f15                	sub	a4,a4,a3
    80001c46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c48:	577d                	li	a4,-1
    80001c4a:	177e                	sll	a4,a4,0x3f
    80001c4c:	8d59                	or	a0,a0,a4
    80001c4e:	9782                	jalr	a5
}
    80001c50:	60a2                	ld	ra,8(sp)
    80001c52:	6402                	ld	s0,0(sp)
    80001c54:	0141                	add	sp,sp,16
    80001c56:	8082                	ret

0000000080001c58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c58:	1101                	add	sp,sp,-32
    80001c5a:	ec06                	sd	ra,24(sp)
    80001c5c:	e822                	sd	s0,16(sp)
    80001c5e:	e426                	sd	s1,8(sp)
    80001c60:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001c62:	0000d497          	auipc	s1,0xd
    80001c66:	aee48493          	add	s1,s1,-1298 # 8000e750 <tickslock>
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	00004097          	auipc	ra,0x4
    80001c70:	6a0080e7          	jalr	1696(ra) # 8000630c <acquire>
  ticks++;
    80001c74:	00007517          	auipc	a0,0x7
    80001c78:	c7450513          	add	a0,a0,-908 # 800088e8 <ticks>
    80001c7c:	411c                	lw	a5,0(a0)
    80001c7e:	2785                	addw	a5,a5,1
    80001c80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c82:	00000097          	auipc	ra,0x0
    80001c86:	996080e7          	jalr	-1642(ra) # 80001618 <wakeup>
  release(&tickslock);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	734080e7          	jalr	1844(ra) # 800063c0 <release>
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	add	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c9e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ca2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ca4:	0a07d163          	bgez	a5,80001d46 <devintr+0xa8>
{
    80001ca8:	1101                	add	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001cb0:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001cb4:	46a5                	li	a3,9
    80001cb6:	00d70c63          	beq	a4,a3,80001cce <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001cba:	577d                	li	a4,-1
    80001cbc:	177e                	sll	a4,a4,0x3f
    80001cbe:	0705                	add	a4,a4,1
    return 0;
    80001cc0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cc2:	06e78163          	beq	a5,a4,80001d24 <devintr+0x86>
  }
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	6105                	add	sp,sp,32
    80001ccc:	8082                	ret
    80001cce:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001cd0:	00003097          	auipc	ra,0x3
    80001cd4:	59c080e7          	jalr	1436(ra) # 8000526c <plic_claim>
    80001cd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cda:	47a9                	li	a5,10
    80001cdc:	00f50963          	beq	a0,a5,80001cee <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001ce0:	4785                	li	a5,1
    80001ce2:	00f50b63          	beq	a0,a5,80001cf8 <devintr+0x5a>
    return 1;
    80001ce6:	4505                	li	a0,1
    } else if(irq){
    80001ce8:	ec89                	bnez	s1,80001d02 <devintr+0x64>
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	bfe9                	j	80001cc6 <devintr+0x28>
      uartintr();
    80001cee:	00004097          	auipc	ra,0x4
    80001cf2:	53e080e7          	jalr	1342(ra) # 8000622c <uartintr>
    if(irq)
    80001cf6:	a839                	j	80001d14 <devintr+0x76>
      virtio_disk_intr();
    80001cf8:	00004097          	auipc	ra,0x4
    80001cfc:	a9e080e7          	jalr	-1378(ra) # 80005796 <virtio_disk_intr>
    if(irq)
    80001d00:	a811                	j	80001d14 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d02:	85a6                	mv	a1,s1
    80001d04:	00006517          	auipc	a0,0x6
    80001d08:	58c50513          	add	a0,a0,1420 # 80008290 <etext+0x290>
    80001d0c:	00004097          	auipc	ra,0x4
    80001d10:	0d0080e7          	jalr	208(ra) # 80005ddc <printf>
      plic_complete(irq);
    80001d14:	8526                	mv	a0,s1
    80001d16:	00003097          	auipc	ra,0x3
    80001d1a:	57a080e7          	jalr	1402(ra) # 80005290 <plic_complete>
    return 1;
    80001d1e:	4505                	li	a0,1
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	b755                	j	80001cc6 <devintr+0x28>
    if(cpuid() == 0){
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	1b6080e7          	jalr	438(ra) # 80000eda <cpuid>
    80001d2c:	c901                	beqz	a0,80001d3c <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d2e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d32:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d34:	14479073          	csrw	sip,a5
    return 2;
    80001d38:	4509                	li	a0,2
    80001d3a:	b771                	j	80001cc6 <devintr+0x28>
      clockintr();
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	f1c080e7          	jalr	-228(ra) # 80001c58 <clockintr>
    80001d44:	b7ed                	j	80001d2e <devintr+0x90>
}
    80001d46:	8082                	ret

0000000080001d48 <usertrap>:
{
    80001d48:	1101                	add	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d54:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d58:	1007f793          	and	a5,a5,256
    80001d5c:	e3b1                	bnez	a5,80001da0 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d5e:	00003797          	auipc	a5,0x3
    80001d62:	40278793          	add	a5,a5,1026 # 80005160 <kernelvec>
    80001d66:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	19c080e7          	jalr	412(ra) # 80000f06 <myproc>
    80001d72:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d74:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d76:	14102773          	csrr	a4,sepc
    80001d7a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d80:	47a1                	li	a5,8
    80001d82:	02f70763          	beq	a4,a5,80001db0 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	f18080e7          	jalr	-232(ra) # 80001c9e <devintr>
    80001d8e:	892a                	mv	s2,a0
    80001d90:	c151                	beqz	a0,80001e14 <usertrap+0xcc>
  if(killed(p))
    80001d92:	8526                	mv	a0,s1
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	ac8080e7          	jalr	-1336(ra) # 8000185c <killed>
    80001d9c:	c929                	beqz	a0,80001dee <usertrap+0xa6>
    80001d9e:	a099                	j	80001de4 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	51050513          	add	a0,a0,1296 # 800082b0 <etext+0x2b0>
    80001da8:	00004097          	auipc	ra,0x4
    80001dac:	fea080e7          	jalr	-22(ra) # 80005d92 <panic>
    if(killed(p))
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	aac080e7          	jalr	-1364(ra) # 8000185c <killed>
    80001db8:	e921                	bnez	a0,80001e08 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001dba:	6cb8                	ld	a4,88(s1)
    80001dbc:	6f1c                	ld	a5,24(a4)
    80001dbe:	0791                	add	a5,a5,4
    80001dc0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dc6:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dca:	10079073          	csrw	sstatus,a5
    syscall();
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	2d4080e7          	jalr	724(ra) # 800020a2 <syscall>
  if(killed(p))
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	a84080e7          	jalr	-1404(ra) # 8000185c <killed>
    80001de0:	c911                	beqz	a0,80001df4 <usertrap+0xac>
    80001de2:	4901                	li	s2,0
    exit(-1);
    80001de4:	557d                	li	a0,-1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	902080e7          	jalr	-1790(ra) # 800016e8 <exit>
  if(which_dev == 2)
    80001dee:	4789                	li	a5,2
    80001df0:	04f90f63          	beq	s2,a5,80001e4e <usertrap+0x106>
  usertrapret();
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	dce080e7          	jalr	-562(ra) # 80001bc2 <usertrapret>
}
    80001dfc:	60e2                	ld	ra,24(sp)
    80001dfe:	6442                	ld	s0,16(sp)
    80001e00:	64a2                	ld	s1,8(sp)
    80001e02:	6902                	ld	s2,0(sp)
    80001e04:	6105                	add	sp,sp,32
    80001e06:	8082                	ret
      exit(-1);
    80001e08:	557d                	li	a0,-1
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	8de080e7          	jalr	-1826(ra) # 800016e8 <exit>
    80001e12:	b765                	j	80001dba <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e14:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e18:	5890                	lw	a2,48(s1)
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	4b650513          	add	a0,a0,1206 # 800082d0 <etext+0x2d0>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	fba080e7          	jalr	-70(ra) # 80005ddc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e2e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	4ce50513          	add	a0,a0,1230 # 80008300 <etext+0x300>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	fa2080e7          	jalr	-94(ra) # 80005ddc <printf>
    setkilled(p);
    80001e42:	8526                	mv	a0,s1
    80001e44:	00000097          	auipc	ra,0x0
    80001e48:	9ec080e7          	jalr	-1556(ra) # 80001830 <setkilled>
    80001e4c:	b769                	j	80001dd6 <usertrap+0x8e>
    yield();
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	72a080e7          	jalr	1834(ra) # 80001578 <yield>
    80001e56:	bf79                	j	80001df4 <usertrap+0xac>

0000000080001e58 <kerneltrap>:
{
    80001e58:	7179                	add	sp,sp,-48
    80001e5a:	f406                	sd	ra,40(sp)
    80001e5c:	f022                	sd	s0,32(sp)
    80001e5e:	ec26                	sd	s1,24(sp)
    80001e60:	e84a                	sd	s2,16(sp)
    80001e62:	e44e                	sd	s3,8(sp)
    80001e64:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e66:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e72:	1004f793          	and	a5,s1,256
    80001e76:	cb85                	beqz	a5,80001ea6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e7c:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001e7e:	ef85                	bnez	a5,80001eb6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e80:	00000097          	auipc	ra,0x0
    80001e84:	e1e080e7          	jalr	-482(ra) # 80001c9e <devintr>
    80001e88:	cd1d                	beqz	a0,80001ec6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e8a:	4789                	li	a5,2
    80001e8c:	06f50a63          	beq	a0,a5,80001f00 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e90:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e94:	10049073          	csrw	sstatus,s1
}
    80001e98:	70a2                	ld	ra,40(sp)
    80001e9a:	7402                	ld	s0,32(sp)
    80001e9c:	64e2                	ld	s1,24(sp)
    80001e9e:	6942                	ld	s2,16(sp)
    80001ea0:	69a2                	ld	s3,8(sp)
    80001ea2:	6145                	add	sp,sp,48
    80001ea4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ea6:	00006517          	auipc	a0,0x6
    80001eaa:	47a50513          	add	a0,a0,1146 # 80008320 <etext+0x320>
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	ee4080e7          	jalr	-284(ra) # 80005d92 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	49250513          	add	a0,a0,1170 # 80008348 <etext+0x348>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	ed4080e7          	jalr	-300(ra) # 80005d92 <panic>
    printf("scause %p\n", scause);
    80001ec6:	85ce                	mv	a1,s3
    80001ec8:	00006517          	auipc	a0,0x6
    80001ecc:	4a050513          	add	a0,a0,1184 # 80008368 <etext+0x368>
    80001ed0:	00004097          	auipc	ra,0x4
    80001ed4:	f0c080e7          	jalr	-244(ra) # 80005ddc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001edc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ee0:	00006517          	auipc	a0,0x6
    80001ee4:	49850513          	add	a0,a0,1176 # 80008378 <etext+0x378>
    80001ee8:	00004097          	auipc	ra,0x4
    80001eec:	ef4080e7          	jalr	-268(ra) # 80005ddc <printf>
    panic("kerneltrap");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	4a050513          	add	a0,a0,1184 # 80008390 <etext+0x390>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	e9a080e7          	jalr	-358(ra) # 80005d92 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	006080e7          	jalr	6(ra) # 80000f06 <myproc>
    80001f08:	d541                	beqz	a0,80001e90 <kerneltrap+0x38>
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	ffc080e7          	jalr	-4(ra) # 80000f06 <myproc>
    80001f12:	4d18                	lw	a4,24(a0)
    80001f14:	4791                	li	a5,4
    80001f16:	f6f71de3          	bne	a4,a5,80001e90 <kerneltrap+0x38>
    yield();
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	65e080e7          	jalr	1630(ra) # 80001578 <yield>
    80001f22:	b7bd                	j	80001e90 <kerneltrap+0x38>

0000000080001f24 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f24:	1101                	add	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	1000                	add	s0,sp,32
    80001f2e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	fd6080e7          	jalr	-42(ra) # 80000f06 <myproc>
  switch (n) {
    80001f38:	4795                	li	a5,5
    80001f3a:	0497e163          	bltu	a5,s1,80001f7c <argraw+0x58>
    80001f3e:	048a                	sll	s1,s1,0x2
    80001f40:	00007717          	auipc	a4,0x7
    80001f44:	86070713          	add	a4,a4,-1952 # 800087a0 <states.0+0x30>
    80001f48:	94ba                	add	s1,s1,a4
    80001f4a:	409c                	lw	a5,0(s1)
    80001f4c:	97ba                	add	a5,a5,a4
    80001f4e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f50:	6d3c                	ld	a5,88(a0)
    80001f52:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6105                	add	sp,sp,32
    80001f5c:	8082                	ret
    return p->trapframe->a1;
    80001f5e:	6d3c                	ld	a5,88(a0)
    80001f60:	7fa8                	ld	a0,120(a5)
    80001f62:	bfcd                	j	80001f54 <argraw+0x30>
    return p->trapframe->a2;
    80001f64:	6d3c                	ld	a5,88(a0)
    80001f66:	63c8                	ld	a0,128(a5)
    80001f68:	b7f5                	j	80001f54 <argraw+0x30>
    return p->trapframe->a3;
    80001f6a:	6d3c                	ld	a5,88(a0)
    80001f6c:	67c8                	ld	a0,136(a5)
    80001f6e:	b7dd                	j	80001f54 <argraw+0x30>
    return p->trapframe->a4;
    80001f70:	6d3c                	ld	a5,88(a0)
    80001f72:	6bc8                	ld	a0,144(a5)
    80001f74:	b7c5                	j	80001f54 <argraw+0x30>
    return p->trapframe->a5;
    80001f76:	6d3c                	ld	a5,88(a0)
    80001f78:	6fc8                	ld	a0,152(a5)
    80001f7a:	bfe9                	j	80001f54 <argraw+0x30>
  panic("argraw");
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	42450513          	add	a0,a0,1060 # 800083a0 <etext+0x3a0>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	e0e080e7          	jalr	-498(ra) # 80005d92 <panic>

0000000080001f8c <fetchaddr>:
{
    80001f8c:	1101                	add	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	e04a                	sd	s2,0(sp)
    80001f96:	1000                	add	s0,sp,32
    80001f98:	84aa                	mv	s1,a0
    80001f9a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	f6a080e7          	jalr	-150(ra) # 80000f06 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fa4:	653c                	ld	a5,72(a0)
    80001fa6:	02f4f863          	bgeu	s1,a5,80001fd6 <fetchaddr+0x4a>
    80001faa:	00848713          	add	a4,s1,8
    80001fae:	02e7e663          	bltu	a5,a4,80001fda <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fb2:	46a1                	li	a3,8
    80001fb4:	8626                	mv	a2,s1
    80001fb6:	85ca                	mv	a1,s2
    80001fb8:	6928                	ld	a0,80(a0)
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	c70080e7          	jalr	-912(ra) # 80000c2a <copyin>
    80001fc2:	00a03533          	snez	a0,a0
    80001fc6:	40a00533          	neg	a0,a0
}
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6902                	ld	s2,0(sp)
    80001fd2:	6105                	add	sp,sp,32
    80001fd4:	8082                	ret
    return -1;
    80001fd6:	557d                	li	a0,-1
    80001fd8:	bfcd                	j	80001fca <fetchaddr+0x3e>
    80001fda:	557d                	li	a0,-1
    80001fdc:	b7fd                	j	80001fca <fetchaddr+0x3e>

0000000080001fde <fetchstr>:
{
    80001fde:	7179                	add	sp,sp,-48
    80001fe0:	f406                	sd	ra,40(sp)
    80001fe2:	f022                	sd	s0,32(sp)
    80001fe4:	ec26                	sd	s1,24(sp)
    80001fe6:	e84a                	sd	s2,16(sp)
    80001fe8:	e44e                	sd	s3,8(sp)
    80001fea:	1800                	add	s0,sp,48
    80001fec:	892a                	mv	s2,a0
    80001fee:	84ae                	mv	s1,a1
    80001ff0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	f14080e7          	jalr	-236(ra) # 80000f06 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ffa:	86ce                	mv	a3,s3
    80001ffc:	864a                	mv	a2,s2
    80001ffe:	85a6                	mv	a1,s1
    80002000:	6928                	ld	a0,80(a0)
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	cb6080e7          	jalr	-842(ra) # 80000cb8 <copyinstr>
    8000200a:	00054e63          	bltz	a0,80002026 <fetchstr+0x48>
  return strlen(buf);
    8000200e:	8526                	mv	a0,s1
    80002010:	ffffe097          	auipc	ra,0xffffe
    80002014:	2de080e7          	jalr	734(ra) # 800002ee <strlen>
}
    80002018:	70a2                	ld	ra,40(sp)
    8000201a:	7402                	ld	s0,32(sp)
    8000201c:	64e2                	ld	s1,24(sp)
    8000201e:	6942                	ld	s2,16(sp)
    80002020:	69a2                	ld	s3,8(sp)
    80002022:	6145                	add	sp,sp,48
    80002024:	8082                	ret
    return -1;
    80002026:	557d                	li	a0,-1
    80002028:	bfc5                	j	80002018 <fetchstr+0x3a>

000000008000202a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000202a:	1101                	add	sp,sp,-32
    8000202c:	ec06                	sd	ra,24(sp)
    8000202e:	e822                	sd	s0,16(sp)
    80002030:	e426                	sd	s1,8(sp)
    80002032:	1000                	add	s0,sp,32
    80002034:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	eee080e7          	jalr	-274(ra) # 80001f24 <argraw>
    8000203e:	c088                	sw	a0,0(s1)
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6105                	add	sp,sp,32
    80002048:	8082                	ret

000000008000204a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000204a:	1101                	add	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	e426                	sd	s1,8(sp)
    80002052:	1000                	add	s0,sp,32
    80002054:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	ece080e7          	jalr	-306(ra) # 80001f24 <argraw>
    8000205e:	e088                	sd	a0,0(s1)
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6105                	add	sp,sp,32
    80002068:	8082                	ret

000000008000206a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000206a:	7179                	add	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	1800                	add	s0,sp,48
    80002076:	84ae                	mv	s1,a1
    80002078:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000207a:	fd840593          	add	a1,s0,-40
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	fcc080e7          	jalr	-52(ra) # 8000204a <argaddr>
  return fetchstr(addr, buf, max);
    80002086:	864a                	mv	a2,s2
    80002088:	85a6                	mv	a1,s1
    8000208a:	fd843503          	ld	a0,-40(s0)
    8000208e:	00000097          	auipc	ra,0x0
    80002092:	f50080e7          	jalr	-176(ra) # 80001fde <fetchstr>
}
    80002096:	70a2                	ld	ra,40(sp)
    80002098:	7402                	ld	s0,32(sp)
    8000209a:	64e2                	ld	s1,24(sp)
    8000209c:	6942                	ld	s2,16(sp)
    8000209e:	6145                	add	sp,sp,48
    800020a0:	8082                	ret

00000000800020a2 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020a2:	1101                	add	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	e04a                	sd	s2,0(sp)
    800020ac:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	e58080e7          	jalr	-424(ra) # 80000f06 <myproc>
    800020b6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020b8:	05853903          	ld	s2,88(a0)
    800020bc:	0a893783          	ld	a5,168(s2)
    800020c0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020c4:	37fd                	addw	a5,a5,-1
    800020c6:	4751                	li	a4,20
    800020c8:	00f76f63          	bltu	a4,a5,800020e6 <syscall+0x44>
    800020cc:	00369713          	sll	a4,a3,0x3
    800020d0:	00006797          	auipc	a5,0x6
    800020d4:	6e878793          	add	a5,a5,1768 # 800087b8 <syscalls>
    800020d8:	97ba                	add	a5,a5,a4
    800020da:	639c                	ld	a5,0(a5)
    800020dc:	c789                	beqz	a5,800020e6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020de:	9782                	jalr	a5
    800020e0:	06a93823          	sd	a0,112(s2)
    800020e4:	a839                	j	80002102 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020e6:	15848613          	add	a2,s1,344
    800020ea:	588c                	lw	a1,48(s1)
    800020ec:	00006517          	auipc	a0,0x6
    800020f0:	2bc50513          	add	a0,a0,700 # 800083a8 <etext+0x3a8>
    800020f4:	00004097          	auipc	ra,0x4
    800020f8:	ce8080e7          	jalr	-792(ra) # 80005ddc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020fc:	6cbc                	ld	a5,88(s1)
    800020fe:	577d                	li	a4,-1
    80002100:	fbb8                	sd	a4,112(a5)
  }
}
    80002102:	60e2                	ld	ra,24(sp)
    80002104:	6442                	ld	s0,16(sp)
    80002106:	64a2                	ld	s1,8(sp)
    80002108:	6902                	ld	s2,0(sp)
    8000210a:	6105                	add	sp,sp,32
    8000210c:	8082                	ret

000000008000210e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000210e:	1101                	add	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002116:	fec40593          	add	a1,s0,-20
    8000211a:	4501                	li	a0,0
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	f0e080e7          	jalr	-242(ra) # 8000202a <argint>
  exit(n);
    80002124:	fec42503          	lw	a0,-20(s0)
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	5c0080e7          	jalr	1472(ra) # 800016e8 <exit>
  return 0;  // not reached
}
    80002130:	4501                	li	a0,0
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	6105                	add	sp,sp,32
    80002138:	8082                	ret

000000008000213a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000213a:	1141                	add	sp,sp,-16
    8000213c:	e406                	sd	ra,8(sp)
    8000213e:	e022                	sd	s0,0(sp)
    80002140:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	dc4080e7          	jalr	-572(ra) # 80000f06 <myproc>
}
    8000214a:	5908                	lw	a0,48(a0)
    8000214c:	60a2                	ld	ra,8(sp)
    8000214e:	6402                	ld	s0,0(sp)
    80002150:	0141                	add	sp,sp,16
    80002152:	8082                	ret

0000000080002154 <sys_fork>:

uint64
sys_fork(void)
{
    80002154:	1141                	add	sp,sp,-16
    80002156:	e406                	sd	ra,8(sp)
    80002158:	e022                	sd	s0,0(sp)
    8000215a:	0800                	add	s0,sp,16
  return fork();
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	164080e7          	jalr	356(ra) # 800012c0 <fork>
}
    80002164:	60a2                	ld	ra,8(sp)
    80002166:	6402                	ld	s0,0(sp)
    80002168:	0141                	add	sp,sp,16
    8000216a:	8082                	ret

000000008000216c <sys_wait>:

uint64
sys_wait(void)
{
    8000216c:	1101                	add	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002174:	fe840593          	add	a1,s0,-24
    80002178:	4501                	li	a0,0
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	ed0080e7          	jalr	-304(ra) # 8000204a <argaddr>
  return wait(p);
    80002182:	fe843503          	ld	a0,-24(s0)
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	708080e7          	jalr	1800(ra) # 8000188e <wait>
}
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	6105                	add	sp,sp,32
    80002194:	8082                	ret

0000000080002196 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002196:	7179                	add	sp,sp,-48
    80002198:	f406                	sd	ra,40(sp)
    8000219a:	f022                	sd	s0,32(sp)
    8000219c:	ec26                	sd	s1,24(sp)
    8000219e:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021a0:	fdc40593          	add	a1,s0,-36
    800021a4:	4501                	li	a0,0
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	e84080e7          	jalr	-380(ra) # 8000202a <argint>
  addr = myproc()->sz;
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	d58080e7          	jalr	-680(ra) # 80000f06 <myproc>
    800021b6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021b8:	fdc42503          	lw	a0,-36(s0)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	0a8080e7          	jalr	168(ra) # 80001264 <growproc>
    800021c4:	00054863          	bltz	a0,800021d4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021c8:	8526                	mv	a0,s1
    800021ca:	70a2                	ld	ra,40(sp)
    800021cc:	7402                	ld	s0,32(sp)
    800021ce:	64e2                	ld	s1,24(sp)
    800021d0:	6145                	add	sp,sp,48
    800021d2:	8082                	ret
    return -1;
    800021d4:	54fd                	li	s1,-1
    800021d6:	bfcd                	j	800021c8 <sys_sbrk+0x32>

00000000800021d8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d8:	7139                	add	sp,sp,-64
    800021da:	fc06                	sd	ra,56(sp)
    800021dc:	f822                	sd	s0,48(sp)
    800021de:	f04a                	sd	s2,32(sp)
    800021e0:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021e2:	fcc40593          	add	a1,s0,-52
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	e42080e7          	jalr	-446(ra) # 8000202a <argint>
  if(n < 0)
    800021f0:	fcc42783          	lw	a5,-52(s0)
    800021f4:	0807c163          	bltz	a5,80002276 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021f8:	0000c517          	auipc	a0,0xc
    800021fc:	55850513          	add	a0,a0,1368 # 8000e750 <tickslock>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	10c080e7          	jalr	268(ra) # 8000630c <acquire>
  ticks0 = ticks;
    80002208:	00006917          	auipc	s2,0x6
    8000220c:	6e092903          	lw	s2,1760(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    80002210:	fcc42783          	lw	a5,-52(s0)
    80002214:	c3b9                	beqz	a5,8000225a <sys_sleep+0x82>
    80002216:	f426                	sd	s1,40(sp)
    80002218:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000221a:	0000c997          	auipc	s3,0xc
    8000221e:	53698993          	add	s3,s3,1334 # 8000e750 <tickslock>
    80002222:	00006497          	auipc	s1,0x6
    80002226:	6c648493          	add	s1,s1,1734 # 800088e8 <ticks>
    if(killed(myproc())){
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	cdc080e7          	jalr	-804(ra) # 80000f06 <myproc>
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	62a080e7          	jalr	1578(ra) # 8000185c <killed>
    8000223a:	e129                	bnez	a0,8000227c <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000223c:	85ce                	mv	a1,s3
    8000223e:	8526                	mv	a0,s1
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	374080e7          	jalr	884(ra) # 800015b4 <sleep>
  while(ticks - ticks0 < n){
    80002248:	409c                	lw	a5,0(s1)
    8000224a:	412787bb          	subw	a5,a5,s2
    8000224e:	fcc42703          	lw	a4,-52(s0)
    80002252:	fce7ece3          	bltu	a5,a4,8000222a <sys_sleep+0x52>
    80002256:	74a2                	ld	s1,40(sp)
    80002258:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000225a:	0000c517          	auipc	a0,0xc
    8000225e:	4f650513          	add	a0,a0,1270 # 8000e750 <tickslock>
    80002262:	00004097          	auipc	ra,0x4
    80002266:	15e080e7          	jalr	350(ra) # 800063c0 <release>
  return 0;
    8000226a:	4501                	li	a0,0
}
    8000226c:	70e2                	ld	ra,56(sp)
    8000226e:	7442                	ld	s0,48(sp)
    80002270:	7902                	ld	s2,32(sp)
    80002272:	6121                	add	sp,sp,64
    80002274:	8082                	ret
    n = 0;
    80002276:	fc042623          	sw	zero,-52(s0)
    8000227a:	bfbd                	j	800021f8 <sys_sleep+0x20>
      release(&tickslock);
    8000227c:	0000c517          	auipc	a0,0xc
    80002280:	4d450513          	add	a0,a0,1236 # 8000e750 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	13c080e7          	jalr	316(ra) # 800063c0 <release>
      return -1;
    8000228c:	557d                	li	a0,-1
    8000228e:	74a2                	ld	s1,40(sp)
    80002290:	69e2                	ld	s3,24(sp)
    80002292:	bfe9                	j	8000226c <sys_sleep+0x94>

0000000080002294 <sys_kill>:

uint64
sys_kill(void)
{
    80002294:	1101                	add	sp,sp,-32
    80002296:	ec06                	sd	ra,24(sp)
    80002298:	e822                	sd	s0,16(sp)
    8000229a:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    8000229c:	fec40593          	add	a1,s0,-20
    800022a0:	4501                	li	a0,0
    800022a2:	00000097          	auipc	ra,0x0
    800022a6:	d88080e7          	jalr	-632(ra) # 8000202a <argint>
  return kill(pid);
    800022aa:	fec42503          	lw	a0,-20(s0)
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	510080e7          	jalr	1296(ra) # 800017be <kill>
}
    800022b6:	60e2                	ld	ra,24(sp)
    800022b8:	6442                	ld	s0,16(sp)
    800022ba:	6105                	add	sp,sp,32
    800022bc:	8082                	ret

00000000800022be <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022be:	1101                	add	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	e426                	sd	s1,8(sp)
    800022c6:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022c8:	0000c517          	auipc	a0,0xc
    800022cc:	48850513          	add	a0,a0,1160 # 8000e750 <tickslock>
    800022d0:	00004097          	auipc	ra,0x4
    800022d4:	03c080e7          	jalr	60(ra) # 8000630c <acquire>
  xticks = ticks;
    800022d8:	00006497          	auipc	s1,0x6
    800022dc:	6104a483          	lw	s1,1552(s1) # 800088e8 <ticks>
  release(&tickslock);
    800022e0:	0000c517          	auipc	a0,0xc
    800022e4:	47050513          	add	a0,a0,1136 # 8000e750 <tickslock>
    800022e8:	00004097          	auipc	ra,0x4
    800022ec:	0d8080e7          	jalr	216(ra) # 800063c0 <release>
  return xticks;
}
    800022f0:	02049513          	sll	a0,s1,0x20
    800022f4:	9101                	srl	a0,a0,0x20
    800022f6:	60e2                	ld	ra,24(sp)
    800022f8:	6442                	ld	s0,16(sp)
    800022fa:	64a2                	ld	s1,8(sp)
    800022fc:	6105                	add	sp,sp,32
    800022fe:	8082                	ret

0000000080002300 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002300:	7179                	add	sp,sp,-48
    80002302:	f406                	sd	ra,40(sp)
    80002304:	f022                	sd	s0,32(sp)
    80002306:	ec26                	sd	s1,24(sp)
    80002308:	e84a                	sd	s2,16(sp)
    8000230a:	e44e                	sd	s3,8(sp)
    8000230c:	e052                	sd	s4,0(sp)
    8000230e:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002310:	00006597          	auipc	a1,0x6
    80002314:	0b858593          	add	a1,a1,184 # 800083c8 <etext+0x3c8>
    80002318:	0000c517          	auipc	a0,0xc
    8000231c:	45050513          	add	a0,a0,1104 # 8000e768 <bcache>
    80002320:	00004097          	auipc	ra,0x4
    80002324:	f5c080e7          	jalr	-164(ra) # 8000627c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002328:	00014797          	auipc	a5,0x14
    8000232c:	44078793          	add	a5,a5,1088 # 80016768 <bcache+0x8000>
    80002330:	00014717          	auipc	a4,0x14
    80002334:	6a070713          	add	a4,a4,1696 # 800169d0 <bcache+0x8268>
    80002338:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000233c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002340:	0000c497          	auipc	s1,0xc
    80002344:	44048493          	add	s1,s1,1088 # 8000e780 <bcache+0x18>
    b->next = bcache.head.next;
    80002348:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000234a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000234c:	00006a17          	auipc	s4,0x6
    80002350:	084a0a13          	add	s4,s4,132 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    80002354:	2b893783          	ld	a5,696(s2)
    80002358:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000235a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000235e:	85d2                	mv	a1,s4
    80002360:	01048513          	add	a0,s1,16
    80002364:	00001097          	auipc	ra,0x1
    80002368:	4e8080e7          	jalr	1256(ra) # 8000384c <initsleeplock>
    bcache.head.next->prev = b;
    8000236c:	2b893783          	ld	a5,696(s2)
    80002370:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002372:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002376:	45848493          	add	s1,s1,1112
    8000237a:	fd349de3          	bne	s1,s3,80002354 <binit+0x54>
  }
}
    8000237e:	70a2                	ld	ra,40(sp)
    80002380:	7402                	ld	s0,32(sp)
    80002382:	64e2                	ld	s1,24(sp)
    80002384:	6942                	ld	s2,16(sp)
    80002386:	69a2                	ld	s3,8(sp)
    80002388:	6a02                	ld	s4,0(sp)
    8000238a:	6145                	add	sp,sp,48
    8000238c:	8082                	ret

000000008000238e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000238e:	7179                	add	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	ec26                	sd	s1,24(sp)
    80002396:	e84a                	sd	s2,16(sp)
    80002398:	e44e                	sd	s3,8(sp)
    8000239a:	1800                	add	s0,sp,48
    8000239c:	892a                	mv	s2,a0
    8000239e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023a0:	0000c517          	auipc	a0,0xc
    800023a4:	3c850513          	add	a0,a0,968 # 8000e768 <bcache>
    800023a8:	00004097          	auipc	ra,0x4
    800023ac:	f64080e7          	jalr	-156(ra) # 8000630c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023b0:	00014497          	auipc	s1,0x14
    800023b4:	6704b483          	ld	s1,1648(s1) # 80016a20 <bcache+0x82b8>
    800023b8:	00014797          	auipc	a5,0x14
    800023bc:	61878793          	add	a5,a5,1560 # 800169d0 <bcache+0x8268>
    800023c0:	02f48f63          	beq	s1,a5,800023fe <bread+0x70>
    800023c4:	873e                	mv	a4,a5
    800023c6:	a021                	j	800023ce <bread+0x40>
    800023c8:	68a4                	ld	s1,80(s1)
    800023ca:	02e48a63          	beq	s1,a4,800023fe <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023ce:	449c                	lw	a5,8(s1)
    800023d0:	ff279ce3          	bne	a5,s2,800023c8 <bread+0x3a>
    800023d4:	44dc                	lw	a5,12(s1)
    800023d6:	ff3799e3          	bne	a5,s3,800023c8 <bread+0x3a>
      b->refcnt++;
    800023da:	40bc                	lw	a5,64(s1)
    800023dc:	2785                	addw	a5,a5,1
    800023de:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e0:	0000c517          	auipc	a0,0xc
    800023e4:	38850513          	add	a0,a0,904 # 8000e768 <bcache>
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	fd8080e7          	jalr	-40(ra) # 800063c0 <release>
      acquiresleep(&b->lock);
    800023f0:	01048513          	add	a0,s1,16
    800023f4:	00001097          	auipc	ra,0x1
    800023f8:	492080e7          	jalr	1170(ra) # 80003886 <acquiresleep>
      return b;
    800023fc:	a8b9                	j	8000245a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023fe:	00014497          	auipc	s1,0x14
    80002402:	61a4b483          	ld	s1,1562(s1) # 80016a18 <bcache+0x82b0>
    80002406:	00014797          	auipc	a5,0x14
    8000240a:	5ca78793          	add	a5,a5,1482 # 800169d0 <bcache+0x8268>
    8000240e:	00f48863          	beq	s1,a5,8000241e <bread+0x90>
    80002412:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002414:	40bc                	lw	a5,64(s1)
    80002416:	cf81                	beqz	a5,8000242e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002418:	64a4                	ld	s1,72(s1)
    8000241a:	fee49de3          	bne	s1,a4,80002414 <bread+0x86>
  panic("bget: no buffers");
    8000241e:	00006517          	auipc	a0,0x6
    80002422:	fba50513          	add	a0,a0,-70 # 800083d8 <etext+0x3d8>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	96c080e7          	jalr	-1684(ra) # 80005d92 <panic>
      b->dev = dev;
    8000242e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002432:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002436:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000243a:	4785                	li	a5,1
    8000243c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000243e:	0000c517          	auipc	a0,0xc
    80002442:	32a50513          	add	a0,a0,810 # 8000e768 <bcache>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	f7a080e7          	jalr	-134(ra) # 800063c0 <release>
      acquiresleep(&b->lock);
    8000244e:	01048513          	add	a0,s1,16
    80002452:	00001097          	auipc	ra,0x1
    80002456:	434080e7          	jalr	1076(ra) # 80003886 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000245a:	409c                	lw	a5,0(s1)
    8000245c:	cb89                	beqz	a5,8000246e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000245e:	8526                	mv	a0,s1
    80002460:	70a2                	ld	ra,40(sp)
    80002462:	7402                	ld	s0,32(sp)
    80002464:	64e2                	ld	s1,24(sp)
    80002466:	6942                	ld	s2,16(sp)
    80002468:	69a2                	ld	s3,8(sp)
    8000246a:	6145                	add	sp,sp,48
    8000246c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000246e:	4581                	li	a1,0
    80002470:	8526                	mv	a0,s1
    80002472:	00003097          	auipc	ra,0x3
    80002476:	0f6080e7          	jalr	246(ra) # 80005568 <virtio_disk_rw>
    b->valid = 1;
    8000247a:	4785                	li	a5,1
    8000247c:	c09c                	sw	a5,0(s1)
  return b;
    8000247e:	b7c5                	j	8000245e <bread+0xd0>

0000000080002480 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002480:	1101                	add	sp,sp,-32
    80002482:	ec06                	sd	ra,24(sp)
    80002484:	e822                	sd	s0,16(sp)
    80002486:	e426                	sd	s1,8(sp)
    80002488:	1000                	add	s0,sp,32
    8000248a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000248c:	0541                	add	a0,a0,16
    8000248e:	00001097          	auipc	ra,0x1
    80002492:	492080e7          	jalr	1170(ra) # 80003920 <holdingsleep>
    80002496:	cd01                	beqz	a0,800024ae <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002498:	4585                	li	a1,1
    8000249a:	8526                	mv	a0,s1
    8000249c:	00003097          	auipc	ra,0x3
    800024a0:	0cc080e7          	jalr	204(ra) # 80005568 <virtio_disk_rw>
}
    800024a4:	60e2                	ld	ra,24(sp)
    800024a6:	6442                	ld	s0,16(sp)
    800024a8:	64a2                	ld	s1,8(sp)
    800024aa:	6105                	add	sp,sp,32
    800024ac:	8082                	ret
    panic("bwrite");
    800024ae:	00006517          	auipc	a0,0x6
    800024b2:	f4250513          	add	a0,a0,-190 # 800083f0 <etext+0x3f0>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	8dc080e7          	jalr	-1828(ra) # 80005d92 <panic>

00000000800024be <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024be:	1101                	add	sp,sp,-32
    800024c0:	ec06                	sd	ra,24(sp)
    800024c2:	e822                	sd	s0,16(sp)
    800024c4:	e426                	sd	s1,8(sp)
    800024c6:	e04a                	sd	s2,0(sp)
    800024c8:	1000                	add	s0,sp,32
    800024ca:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024cc:	01050913          	add	s2,a0,16
    800024d0:	854a                	mv	a0,s2
    800024d2:	00001097          	auipc	ra,0x1
    800024d6:	44e080e7          	jalr	1102(ra) # 80003920 <holdingsleep>
    800024da:	c925                	beqz	a0,8000254a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800024dc:	854a                	mv	a0,s2
    800024de:	00001097          	auipc	ra,0x1
    800024e2:	3fe080e7          	jalr	1022(ra) # 800038dc <releasesleep>

  acquire(&bcache.lock);
    800024e6:	0000c517          	auipc	a0,0xc
    800024ea:	28250513          	add	a0,a0,642 # 8000e768 <bcache>
    800024ee:	00004097          	auipc	ra,0x4
    800024f2:	e1e080e7          	jalr	-482(ra) # 8000630c <acquire>
  b->refcnt--;
    800024f6:	40bc                	lw	a5,64(s1)
    800024f8:	37fd                	addw	a5,a5,-1
    800024fa:	0007871b          	sext.w	a4,a5
    800024fe:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002500:	e71d                	bnez	a4,8000252e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002502:	68b8                	ld	a4,80(s1)
    80002504:	64bc                	ld	a5,72(s1)
    80002506:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002508:	68b8                	ld	a4,80(s1)
    8000250a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000250c:	00014797          	auipc	a5,0x14
    80002510:	25c78793          	add	a5,a5,604 # 80016768 <bcache+0x8000>
    80002514:	2b87b703          	ld	a4,696(a5)
    80002518:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000251a:	00014717          	auipc	a4,0x14
    8000251e:	4b670713          	add	a4,a4,1206 # 800169d0 <bcache+0x8268>
    80002522:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002524:	2b87b703          	ld	a4,696(a5)
    80002528:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000252a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000252e:	0000c517          	auipc	a0,0xc
    80002532:	23a50513          	add	a0,a0,570 # 8000e768 <bcache>
    80002536:	00004097          	auipc	ra,0x4
    8000253a:	e8a080e7          	jalr	-374(ra) # 800063c0 <release>
}
    8000253e:	60e2                	ld	ra,24(sp)
    80002540:	6442                	ld	s0,16(sp)
    80002542:	64a2                	ld	s1,8(sp)
    80002544:	6902                	ld	s2,0(sp)
    80002546:	6105                	add	sp,sp,32
    80002548:	8082                	ret
    panic("brelse");
    8000254a:	00006517          	auipc	a0,0x6
    8000254e:	eae50513          	add	a0,a0,-338 # 800083f8 <etext+0x3f8>
    80002552:	00004097          	auipc	ra,0x4
    80002556:	840080e7          	jalr	-1984(ra) # 80005d92 <panic>

000000008000255a <bpin>:

void
bpin(struct buf *b) {
    8000255a:	1101                	add	sp,sp,-32
    8000255c:	ec06                	sd	ra,24(sp)
    8000255e:	e822                	sd	s0,16(sp)
    80002560:	e426                	sd	s1,8(sp)
    80002562:	1000                	add	s0,sp,32
    80002564:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002566:	0000c517          	auipc	a0,0xc
    8000256a:	20250513          	add	a0,a0,514 # 8000e768 <bcache>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	d9e080e7          	jalr	-610(ra) # 8000630c <acquire>
  b->refcnt++;
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	2785                	addw	a5,a5,1
    8000257a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000257c:	0000c517          	auipc	a0,0xc
    80002580:	1ec50513          	add	a0,a0,492 # 8000e768 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	e3c080e7          	jalr	-452(ra) # 800063c0 <release>
}
    8000258c:	60e2                	ld	ra,24(sp)
    8000258e:	6442                	ld	s0,16(sp)
    80002590:	64a2                	ld	s1,8(sp)
    80002592:	6105                	add	sp,sp,32
    80002594:	8082                	ret

0000000080002596 <bunpin>:

void
bunpin(struct buf *b) {
    80002596:	1101                	add	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	1000                	add	s0,sp,32
    800025a0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025a2:	0000c517          	auipc	a0,0xc
    800025a6:	1c650513          	add	a0,a0,454 # 8000e768 <bcache>
    800025aa:	00004097          	auipc	ra,0x4
    800025ae:	d62080e7          	jalr	-670(ra) # 8000630c <acquire>
  b->refcnt--;
    800025b2:	40bc                	lw	a5,64(s1)
    800025b4:	37fd                	addw	a5,a5,-1
    800025b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025b8:	0000c517          	auipc	a0,0xc
    800025bc:	1b050513          	add	a0,a0,432 # 8000e768 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	e00080e7          	jalr	-512(ra) # 800063c0 <release>
}
    800025c8:	60e2                	ld	ra,24(sp)
    800025ca:	6442                	ld	s0,16(sp)
    800025cc:	64a2                	ld	s1,8(sp)
    800025ce:	6105                	add	sp,sp,32
    800025d0:	8082                	ret

00000000800025d2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025d2:	1101                	add	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	e04a                	sd	s2,0(sp)
    800025dc:	1000                	add	s0,sp,32
    800025de:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e0:	00d5d59b          	srlw	a1,a1,0xd
    800025e4:	00015797          	auipc	a5,0x15
    800025e8:	8607a783          	lw	a5,-1952(a5) # 80016e44 <sb+0x1c>
    800025ec:	9dbd                	addw	a1,a1,a5
    800025ee:	00000097          	auipc	ra,0x0
    800025f2:	da0080e7          	jalr	-608(ra) # 8000238e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025f6:	0074f713          	and	a4,s1,7
    800025fa:	4785                	li	a5,1
    800025fc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002600:	14ce                	sll	s1,s1,0x33
    80002602:	90d9                	srl	s1,s1,0x36
    80002604:	00950733          	add	a4,a0,s1
    80002608:	05874703          	lbu	a4,88(a4)
    8000260c:	00e7f6b3          	and	a3,a5,a4
    80002610:	c69d                	beqz	a3,8000263e <bfree+0x6c>
    80002612:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002614:	94aa                	add	s1,s1,a0
    80002616:	fff7c793          	not	a5,a5
    8000261a:	8f7d                	and	a4,a4,a5
    8000261c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002620:	00001097          	auipc	ra,0x1
    80002624:	148080e7          	jalr	328(ra) # 80003768 <log_write>
  brelse(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00000097          	auipc	ra,0x0
    8000262e:	e94080e7          	jalr	-364(ra) # 800024be <brelse>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6902                	ld	s2,0(sp)
    8000263a:	6105                	add	sp,sp,32
    8000263c:	8082                	ret
    panic("freeing free block");
    8000263e:	00006517          	auipc	a0,0x6
    80002642:	dc250513          	add	a0,a0,-574 # 80008400 <etext+0x400>
    80002646:	00003097          	auipc	ra,0x3
    8000264a:	74c080e7          	jalr	1868(ra) # 80005d92 <panic>

000000008000264e <balloc>:
{
    8000264e:	711d                	add	sp,sp,-96
    80002650:	ec86                	sd	ra,88(sp)
    80002652:	e8a2                	sd	s0,80(sp)
    80002654:	e4a6                	sd	s1,72(sp)
    80002656:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002658:	00014797          	auipc	a5,0x14
    8000265c:	7d47a783          	lw	a5,2004(a5) # 80016e2c <sb+0x4>
    80002660:	10078f63          	beqz	a5,8000277e <balloc+0x130>
    80002664:	e0ca                	sd	s2,64(sp)
    80002666:	fc4e                	sd	s3,56(sp)
    80002668:	f852                	sd	s4,48(sp)
    8000266a:	f456                	sd	s5,40(sp)
    8000266c:	f05a                	sd	s6,32(sp)
    8000266e:	ec5e                	sd	s7,24(sp)
    80002670:	e862                	sd	s8,16(sp)
    80002672:	e466                	sd	s9,8(sp)
    80002674:	8baa                	mv	s7,a0
    80002676:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002678:	00014b17          	auipc	s6,0x14
    8000267c:	7b0b0b13          	add	s6,s6,1968 # 80016e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002680:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002682:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002684:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002686:	6c89                	lui	s9,0x2
    80002688:	a061                	j	80002710 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000268a:	97ca                	add	a5,a5,s2
    8000268c:	8e55                	or	a2,a2,a3
    8000268e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002692:	854a                	mv	a0,s2
    80002694:	00001097          	auipc	ra,0x1
    80002698:	0d4080e7          	jalr	212(ra) # 80003768 <log_write>
        brelse(bp);
    8000269c:	854a                	mv	a0,s2
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	e20080e7          	jalr	-480(ra) # 800024be <brelse>
  bp = bread(dev, bno);
    800026a6:	85a6                	mv	a1,s1
    800026a8:	855e                	mv	a0,s7
    800026aa:	00000097          	auipc	ra,0x0
    800026ae:	ce4080e7          	jalr	-796(ra) # 8000238e <bread>
    800026b2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026b4:	40000613          	li	a2,1024
    800026b8:	4581                	li	a1,0
    800026ba:	05850513          	add	a0,a0,88
    800026be:	ffffe097          	auipc	ra,0xffffe
    800026c2:	abc080e7          	jalr	-1348(ra) # 8000017a <memset>
  log_write(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	0a0080e7          	jalr	160(ra) # 80003768 <log_write>
  brelse(bp);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	dec080e7          	jalr	-532(ra) # 800024be <brelse>
}
    800026da:	6906                	ld	s2,64(sp)
    800026dc:	79e2                	ld	s3,56(sp)
    800026de:	7a42                	ld	s4,48(sp)
    800026e0:	7aa2                	ld	s5,40(sp)
    800026e2:	7b02                	ld	s6,32(sp)
    800026e4:	6be2                	ld	s7,24(sp)
    800026e6:	6c42                	ld	s8,16(sp)
    800026e8:	6ca2                	ld	s9,8(sp)
}
    800026ea:	8526                	mv	a0,s1
    800026ec:	60e6                	ld	ra,88(sp)
    800026ee:	6446                	ld	s0,80(sp)
    800026f0:	64a6                	ld	s1,72(sp)
    800026f2:	6125                	add	sp,sp,96
    800026f4:	8082                	ret
    brelse(bp);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	dc6080e7          	jalr	-570(ra) # 800024be <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002700:	015c87bb          	addw	a5,s9,s5
    80002704:	00078a9b          	sext.w	s5,a5
    80002708:	004b2703          	lw	a4,4(s6)
    8000270c:	06eaf163          	bgeu	s5,a4,8000276e <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002710:	41fad79b          	sraw	a5,s5,0x1f
    80002714:	0137d79b          	srlw	a5,a5,0x13
    80002718:	015787bb          	addw	a5,a5,s5
    8000271c:	40d7d79b          	sraw	a5,a5,0xd
    80002720:	01cb2583          	lw	a1,28(s6)
    80002724:	9dbd                	addw	a1,a1,a5
    80002726:	855e                	mv	a0,s7
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	c66080e7          	jalr	-922(ra) # 8000238e <bread>
    80002730:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002732:	004b2503          	lw	a0,4(s6)
    80002736:	000a849b          	sext.w	s1,s5
    8000273a:	8762                	mv	a4,s8
    8000273c:	faa4fde3          	bgeu	s1,a0,800026f6 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002740:	00777693          	and	a3,a4,7
    80002744:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002748:	41f7579b          	sraw	a5,a4,0x1f
    8000274c:	01d7d79b          	srlw	a5,a5,0x1d
    80002750:	9fb9                	addw	a5,a5,a4
    80002752:	4037d79b          	sraw	a5,a5,0x3
    80002756:	00f90633          	add	a2,s2,a5
    8000275a:	05864603          	lbu	a2,88(a2)
    8000275e:	00c6f5b3          	and	a1,a3,a2
    80002762:	d585                	beqz	a1,8000268a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002764:	2705                	addw	a4,a4,1
    80002766:	2485                	addw	s1,s1,1
    80002768:	fd471ae3          	bne	a4,s4,8000273c <balloc+0xee>
    8000276c:	b769                	j	800026f6 <balloc+0xa8>
    8000276e:	6906                	ld	s2,64(sp)
    80002770:	79e2                	ld	s3,56(sp)
    80002772:	7a42                	ld	s4,48(sp)
    80002774:	7aa2                	ld	s5,40(sp)
    80002776:	7b02                	ld	s6,32(sp)
    80002778:	6be2                	ld	s7,24(sp)
    8000277a:	6c42                	ld	s8,16(sp)
    8000277c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000277e:	00006517          	auipc	a0,0x6
    80002782:	c9a50513          	add	a0,a0,-870 # 80008418 <etext+0x418>
    80002786:	00003097          	auipc	ra,0x3
    8000278a:	656080e7          	jalr	1622(ra) # 80005ddc <printf>
  return 0;
    8000278e:	4481                	li	s1,0
    80002790:	bfa9                	j	800026ea <balloc+0x9c>

0000000080002792 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002792:	7179                	add	sp,sp,-48
    80002794:	f406                	sd	ra,40(sp)
    80002796:	f022                	sd	s0,32(sp)
    80002798:	ec26                	sd	s1,24(sp)
    8000279a:	e84a                	sd	s2,16(sp)
    8000279c:	e44e                	sd	s3,8(sp)
    8000279e:	1800                	add	s0,sp,48
    800027a0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027a2:	47ad                	li	a5,11
    800027a4:	02b7e863          	bltu	a5,a1,800027d4 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027a8:	02059793          	sll	a5,a1,0x20
    800027ac:	01e7d593          	srl	a1,a5,0x1e
    800027b0:	00b504b3          	add	s1,a0,a1
    800027b4:	0504a903          	lw	s2,80(s1)
    800027b8:	08091263          	bnez	s2,8000283c <bmap+0xaa>
      addr = balloc(ip->dev);
    800027bc:	4108                	lw	a0,0(a0)
    800027be:	00000097          	auipc	ra,0x0
    800027c2:	e90080e7          	jalr	-368(ra) # 8000264e <balloc>
    800027c6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027ca:	06090963          	beqz	s2,8000283c <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    800027ce:	0524a823          	sw	s2,80(s1)
    800027d2:	a0ad                	j	8000283c <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027d4:	ff45849b          	addw	s1,a1,-12
    800027d8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027dc:	0ff00793          	li	a5,255
    800027e0:	08e7e863          	bltu	a5,a4,80002870 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027e4:	08052903          	lw	s2,128(a0)
    800027e8:	00091f63          	bnez	s2,80002806 <bmap+0x74>
      addr = balloc(ip->dev);
    800027ec:	4108                	lw	a0,0(a0)
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	e60080e7          	jalr	-416(ra) # 8000264e <balloc>
    800027f6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027fa:	04090163          	beqz	s2,8000283c <bmap+0xaa>
    800027fe:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002800:	0929a023          	sw	s2,128(s3)
    80002804:	a011                	j	80002808 <bmap+0x76>
    80002806:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002808:	85ca                	mv	a1,s2
    8000280a:	0009a503          	lw	a0,0(s3)
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	b80080e7          	jalr	-1152(ra) # 8000238e <bread>
    80002816:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002818:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    8000281c:	02049713          	sll	a4,s1,0x20
    80002820:	01e75593          	srl	a1,a4,0x1e
    80002824:	00b784b3          	add	s1,a5,a1
    80002828:	0004a903          	lw	s2,0(s1)
    8000282c:	02090063          	beqz	s2,8000284c <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002830:	8552                	mv	a0,s4
    80002832:	00000097          	auipc	ra,0x0
    80002836:	c8c080e7          	jalr	-884(ra) # 800024be <brelse>
    return addr;
    8000283a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000283c:	854a                	mv	a0,s2
    8000283e:	70a2                	ld	ra,40(sp)
    80002840:	7402                	ld	s0,32(sp)
    80002842:	64e2                	ld	s1,24(sp)
    80002844:	6942                	ld	s2,16(sp)
    80002846:	69a2                	ld	s3,8(sp)
    80002848:	6145                	add	sp,sp,48
    8000284a:	8082                	ret
      addr = balloc(ip->dev);
    8000284c:	0009a503          	lw	a0,0(s3)
    80002850:	00000097          	auipc	ra,0x0
    80002854:	dfe080e7          	jalr	-514(ra) # 8000264e <balloc>
    80002858:	0005091b          	sext.w	s2,a0
      if(addr){
    8000285c:	fc090ae3          	beqz	s2,80002830 <bmap+0x9e>
        a[bn] = addr;
    80002860:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002864:	8552                	mv	a0,s4
    80002866:	00001097          	auipc	ra,0x1
    8000286a:	f02080e7          	jalr	-254(ra) # 80003768 <log_write>
    8000286e:	b7c9                	j	80002830 <bmap+0x9e>
    80002870:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002872:	00006517          	auipc	a0,0x6
    80002876:	bbe50513          	add	a0,a0,-1090 # 80008430 <etext+0x430>
    8000287a:	00003097          	auipc	ra,0x3
    8000287e:	518080e7          	jalr	1304(ra) # 80005d92 <panic>

0000000080002882 <iget>:
{
    80002882:	7179                	add	sp,sp,-48
    80002884:	f406                	sd	ra,40(sp)
    80002886:	f022                	sd	s0,32(sp)
    80002888:	ec26                	sd	s1,24(sp)
    8000288a:	e84a                	sd	s2,16(sp)
    8000288c:	e44e                	sd	s3,8(sp)
    8000288e:	e052                	sd	s4,0(sp)
    80002890:	1800                	add	s0,sp,48
    80002892:	89aa                	mv	s3,a0
    80002894:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002896:	00014517          	auipc	a0,0x14
    8000289a:	5b250513          	add	a0,a0,1458 # 80016e48 <itable>
    8000289e:	00004097          	auipc	ra,0x4
    800028a2:	a6e080e7          	jalr	-1426(ra) # 8000630c <acquire>
  empty = 0;
    800028a6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a8:	00014497          	auipc	s1,0x14
    800028ac:	5b848493          	add	s1,s1,1464 # 80016e60 <itable+0x18>
    800028b0:	00016697          	auipc	a3,0x16
    800028b4:	04068693          	add	a3,a3,64 # 800188f0 <log>
    800028b8:	a039                	j	800028c6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ba:	02090b63          	beqz	s2,800028f0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028be:	08848493          	add	s1,s1,136
    800028c2:	02d48a63          	beq	s1,a3,800028f6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028c6:	449c                	lw	a5,8(s1)
    800028c8:	fef059e3          	blez	a5,800028ba <iget+0x38>
    800028cc:	4098                	lw	a4,0(s1)
    800028ce:	ff3716e3          	bne	a4,s3,800028ba <iget+0x38>
    800028d2:	40d8                	lw	a4,4(s1)
    800028d4:	ff4713e3          	bne	a4,s4,800028ba <iget+0x38>
      ip->ref++;
    800028d8:	2785                	addw	a5,a5,1
    800028da:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028dc:	00014517          	auipc	a0,0x14
    800028e0:	56c50513          	add	a0,a0,1388 # 80016e48 <itable>
    800028e4:	00004097          	auipc	ra,0x4
    800028e8:	adc080e7          	jalr	-1316(ra) # 800063c0 <release>
      return ip;
    800028ec:	8926                	mv	s2,s1
    800028ee:	a03d                	j	8000291c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f0:	f7f9                	bnez	a5,800028be <iget+0x3c>
      empty = ip;
    800028f2:	8926                	mv	s2,s1
    800028f4:	b7e9                	j	800028be <iget+0x3c>
  if(empty == 0)
    800028f6:	02090c63          	beqz	s2,8000292e <iget+0xac>
  ip->dev = dev;
    800028fa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028fe:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002902:	4785                	li	a5,1
    80002904:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002908:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000290c:	00014517          	auipc	a0,0x14
    80002910:	53c50513          	add	a0,a0,1340 # 80016e48 <itable>
    80002914:	00004097          	auipc	ra,0x4
    80002918:	aac080e7          	jalr	-1364(ra) # 800063c0 <release>
}
    8000291c:	854a                	mv	a0,s2
    8000291e:	70a2                	ld	ra,40(sp)
    80002920:	7402                	ld	s0,32(sp)
    80002922:	64e2                	ld	s1,24(sp)
    80002924:	6942                	ld	s2,16(sp)
    80002926:	69a2                	ld	s3,8(sp)
    80002928:	6a02                	ld	s4,0(sp)
    8000292a:	6145                	add	sp,sp,48
    8000292c:	8082                	ret
    panic("iget: no inodes");
    8000292e:	00006517          	auipc	a0,0x6
    80002932:	b1a50513          	add	a0,a0,-1254 # 80008448 <etext+0x448>
    80002936:	00003097          	auipc	ra,0x3
    8000293a:	45c080e7          	jalr	1116(ra) # 80005d92 <panic>

000000008000293e <fsinit>:
fsinit(int dev) {
    8000293e:	7179                	add	sp,sp,-48
    80002940:	f406                	sd	ra,40(sp)
    80002942:	f022                	sd	s0,32(sp)
    80002944:	ec26                	sd	s1,24(sp)
    80002946:	e84a                	sd	s2,16(sp)
    80002948:	e44e                	sd	s3,8(sp)
    8000294a:	1800                	add	s0,sp,48
    8000294c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000294e:	4585                	li	a1,1
    80002950:	00000097          	auipc	ra,0x0
    80002954:	a3e080e7          	jalr	-1474(ra) # 8000238e <bread>
    80002958:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000295a:	00014997          	auipc	s3,0x14
    8000295e:	4ce98993          	add	s3,s3,1230 # 80016e28 <sb>
    80002962:	02000613          	li	a2,32
    80002966:	05850593          	add	a1,a0,88
    8000296a:	854e                	mv	a0,s3
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	86a080e7          	jalr	-1942(ra) # 800001d6 <memmove>
  brelse(bp);
    80002974:	8526                	mv	a0,s1
    80002976:	00000097          	auipc	ra,0x0
    8000297a:	b48080e7          	jalr	-1208(ra) # 800024be <brelse>
  if(sb.magic != FSMAGIC)
    8000297e:	0009a703          	lw	a4,0(s3)
    80002982:	102037b7          	lui	a5,0x10203
    80002986:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000298a:	02f71263          	bne	a4,a5,800029ae <fsinit+0x70>
  initlog(dev, &sb);
    8000298e:	00014597          	auipc	a1,0x14
    80002992:	49a58593          	add	a1,a1,1178 # 80016e28 <sb>
    80002996:	854a                	mv	a0,s2
    80002998:	00001097          	auipc	ra,0x1
    8000299c:	b60080e7          	jalr	-1184(ra) # 800034f8 <initlog>
}
    800029a0:	70a2                	ld	ra,40(sp)
    800029a2:	7402                	ld	s0,32(sp)
    800029a4:	64e2                	ld	s1,24(sp)
    800029a6:	6942                	ld	s2,16(sp)
    800029a8:	69a2                	ld	s3,8(sp)
    800029aa:	6145                	add	sp,sp,48
    800029ac:	8082                	ret
    panic("invalid file system");
    800029ae:	00006517          	auipc	a0,0x6
    800029b2:	aaa50513          	add	a0,a0,-1366 # 80008458 <etext+0x458>
    800029b6:	00003097          	auipc	ra,0x3
    800029ba:	3dc080e7          	jalr	988(ra) # 80005d92 <panic>

00000000800029be <iinit>:
{
    800029be:	7179                	add	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	e84a                	sd	s2,16(sp)
    800029c8:	e44e                	sd	s3,8(sp)
    800029ca:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    800029cc:	00006597          	auipc	a1,0x6
    800029d0:	aa458593          	add	a1,a1,-1372 # 80008470 <etext+0x470>
    800029d4:	00014517          	auipc	a0,0x14
    800029d8:	47450513          	add	a0,a0,1140 # 80016e48 <itable>
    800029dc:	00004097          	auipc	ra,0x4
    800029e0:	8a0080e7          	jalr	-1888(ra) # 8000627c <initlock>
  for(i = 0; i < NINODE; i++) {
    800029e4:	00014497          	auipc	s1,0x14
    800029e8:	48c48493          	add	s1,s1,1164 # 80016e70 <itable+0x28>
    800029ec:	00016997          	auipc	s3,0x16
    800029f0:	f1498993          	add	s3,s3,-236 # 80018900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029f4:	00006917          	auipc	s2,0x6
    800029f8:	a8490913          	add	s2,s2,-1404 # 80008478 <etext+0x478>
    800029fc:	85ca                	mv	a1,s2
    800029fe:	8526                	mv	a0,s1
    80002a00:	00001097          	auipc	ra,0x1
    80002a04:	e4c080e7          	jalr	-436(ra) # 8000384c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a08:	08848493          	add	s1,s1,136
    80002a0c:	ff3498e3          	bne	s1,s3,800029fc <iinit+0x3e>
}
    80002a10:	70a2                	ld	ra,40(sp)
    80002a12:	7402                	ld	s0,32(sp)
    80002a14:	64e2                	ld	s1,24(sp)
    80002a16:	6942                	ld	s2,16(sp)
    80002a18:	69a2                	ld	s3,8(sp)
    80002a1a:	6145                	add	sp,sp,48
    80002a1c:	8082                	ret

0000000080002a1e <ialloc>:
{
    80002a1e:	7139                	add	sp,sp,-64
    80002a20:	fc06                	sd	ra,56(sp)
    80002a22:	f822                	sd	s0,48(sp)
    80002a24:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a26:	00014717          	auipc	a4,0x14
    80002a2a:	40e72703          	lw	a4,1038(a4) # 80016e34 <sb+0xc>
    80002a2e:	4785                	li	a5,1
    80002a30:	06e7f463          	bgeu	a5,a4,80002a98 <ialloc+0x7a>
    80002a34:	f426                	sd	s1,40(sp)
    80002a36:	f04a                	sd	s2,32(sp)
    80002a38:	ec4e                	sd	s3,24(sp)
    80002a3a:	e852                	sd	s4,16(sp)
    80002a3c:	e456                	sd	s5,8(sp)
    80002a3e:	e05a                	sd	s6,0(sp)
    80002a40:	8aaa                	mv	s5,a0
    80002a42:	8b2e                	mv	s6,a1
    80002a44:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a46:	00014a17          	auipc	s4,0x14
    80002a4a:	3e2a0a13          	add	s4,s4,994 # 80016e28 <sb>
    80002a4e:	00495593          	srl	a1,s2,0x4
    80002a52:	018a2783          	lw	a5,24(s4)
    80002a56:	9dbd                	addw	a1,a1,a5
    80002a58:	8556                	mv	a0,s5
    80002a5a:	00000097          	auipc	ra,0x0
    80002a5e:	934080e7          	jalr	-1740(ra) # 8000238e <bread>
    80002a62:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a64:	05850993          	add	s3,a0,88
    80002a68:	00f97793          	and	a5,s2,15
    80002a6c:	079a                	sll	a5,a5,0x6
    80002a6e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a70:	00099783          	lh	a5,0(s3)
    80002a74:	cf9d                	beqz	a5,80002ab2 <ialloc+0x94>
    brelse(bp);
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	a48080e7          	jalr	-1464(ra) # 800024be <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a7e:	0905                	add	s2,s2,1
    80002a80:	00ca2703          	lw	a4,12(s4)
    80002a84:	0009079b          	sext.w	a5,s2
    80002a88:	fce7e3e3          	bltu	a5,a4,80002a4e <ialloc+0x30>
    80002a8c:	74a2                	ld	s1,40(sp)
    80002a8e:	7902                	ld	s2,32(sp)
    80002a90:	69e2                	ld	s3,24(sp)
    80002a92:	6a42                	ld	s4,16(sp)
    80002a94:	6aa2                	ld	s5,8(sp)
    80002a96:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	9e850513          	add	a0,a0,-1560 # 80008480 <etext+0x480>
    80002aa0:	00003097          	auipc	ra,0x3
    80002aa4:	33c080e7          	jalr	828(ra) # 80005ddc <printf>
  return 0;
    80002aa8:	4501                	li	a0,0
}
    80002aaa:	70e2                	ld	ra,56(sp)
    80002aac:	7442                	ld	s0,48(sp)
    80002aae:	6121                	add	sp,sp,64
    80002ab0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ab2:	04000613          	li	a2,64
    80002ab6:	4581                	li	a1,0
    80002ab8:	854e                	mv	a0,s3
    80002aba:	ffffd097          	auipc	ra,0xffffd
    80002abe:	6c0080e7          	jalr	1728(ra) # 8000017a <memset>
      dip->type = type;
    80002ac2:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ac6:	8526                	mv	a0,s1
    80002ac8:	00001097          	auipc	ra,0x1
    80002acc:	ca0080e7          	jalr	-864(ra) # 80003768 <log_write>
      brelse(bp);
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	9ec080e7          	jalr	-1556(ra) # 800024be <brelse>
      return iget(dev, inum);
    80002ada:	0009059b          	sext.w	a1,s2
    80002ade:	8556                	mv	a0,s5
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	da2080e7          	jalr	-606(ra) # 80002882 <iget>
    80002ae8:	74a2                	ld	s1,40(sp)
    80002aea:	7902                	ld	s2,32(sp)
    80002aec:	69e2                	ld	s3,24(sp)
    80002aee:	6a42                	ld	s4,16(sp)
    80002af0:	6aa2                	ld	s5,8(sp)
    80002af2:	6b02                	ld	s6,0(sp)
    80002af4:	bf5d                	j	80002aaa <ialloc+0x8c>

0000000080002af6 <iupdate>:
{
    80002af6:	1101                	add	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	e426                	sd	s1,8(sp)
    80002afe:	e04a                	sd	s2,0(sp)
    80002b00:	1000                	add	s0,sp,32
    80002b02:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b04:	415c                	lw	a5,4(a0)
    80002b06:	0047d79b          	srlw	a5,a5,0x4
    80002b0a:	00014597          	auipc	a1,0x14
    80002b0e:	3365a583          	lw	a1,822(a1) # 80016e40 <sb+0x18>
    80002b12:	9dbd                	addw	a1,a1,a5
    80002b14:	4108                	lw	a0,0(a0)
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	878080e7          	jalr	-1928(ra) # 8000238e <bread>
    80002b1e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b20:	05850793          	add	a5,a0,88
    80002b24:	40d8                	lw	a4,4(s1)
    80002b26:	8b3d                	and	a4,a4,15
    80002b28:	071a                	sll	a4,a4,0x6
    80002b2a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b2c:	04449703          	lh	a4,68(s1)
    80002b30:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b34:	04649703          	lh	a4,70(s1)
    80002b38:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b3c:	04849703          	lh	a4,72(s1)
    80002b40:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b44:	04a49703          	lh	a4,74(s1)
    80002b48:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b4c:	44f8                	lw	a4,76(s1)
    80002b4e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b50:	03400613          	li	a2,52
    80002b54:	05048593          	add	a1,s1,80
    80002b58:	00c78513          	add	a0,a5,12
    80002b5c:	ffffd097          	auipc	ra,0xffffd
    80002b60:	67a080e7          	jalr	1658(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b64:	854a                	mv	a0,s2
    80002b66:	00001097          	auipc	ra,0x1
    80002b6a:	c02080e7          	jalr	-1022(ra) # 80003768 <log_write>
  brelse(bp);
    80002b6e:	854a                	mv	a0,s2
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	94e080e7          	jalr	-1714(ra) # 800024be <brelse>
}
    80002b78:	60e2                	ld	ra,24(sp)
    80002b7a:	6442                	ld	s0,16(sp)
    80002b7c:	64a2                	ld	s1,8(sp)
    80002b7e:	6902                	ld	s2,0(sp)
    80002b80:	6105                	add	sp,sp,32
    80002b82:	8082                	ret

0000000080002b84 <idup>:
{
    80002b84:	1101                	add	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	e426                	sd	s1,8(sp)
    80002b8c:	1000                	add	s0,sp,32
    80002b8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b90:	00014517          	auipc	a0,0x14
    80002b94:	2b850513          	add	a0,a0,696 # 80016e48 <itable>
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	774080e7          	jalr	1908(ra) # 8000630c <acquire>
  ip->ref++;
    80002ba0:	449c                	lw	a5,8(s1)
    80002ba2:	2785                	addw	a5,a5,1
    80002ba4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba6:	00014517          	auipc	a0,0x14
    80002baa:	2a250513          	add	a0,a0,674 # 80016e48 <itable>
    80002bae:	00004097          	auipc	ra,0x4
    80002bb2:	812080e7          	jalr	-2030(ra) # 800063c0 <release>
}
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	add	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <ilock>:
{
    80002bc2:	1101                	add	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bcc:	c10d                	beqz	a0,80002bee <ilock+0x2c>
    80002bce:	84aa                	mv	s1,a0
    80002bd0:	451c                	lw	a5,8(a0)
    80002bd2:	00f05e63          	blez	a5,80002bee <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002bd6:	0541                	add	a0,a0,16
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	cae080e7          	jalr	-850(ra) # 80003886 <acquiresleep>
  if(ip->valid == 0){
    80002be0:	40bc                	lw	a5,64(s1)
    80002be2:	cf99                	beqz	a5,80002c00 <ilock+0x3e>
}
    80002be4:	60e2                	ld	ra,24(sp)
    80002be6:	6442                	ld	s0,16(sp)
    80002be8:	64a2                	ld	s1,8(sp)
    80002bea:	6105                	add	sp,sp,32
    80002bec:	8082                	ret
    80002bee:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002bf0:	00006517          	auipc	a0,0x6
    80002bf4:	8a850513          	add	a0,a0,-1880 # 80008498 <etext+0x498>
    80002bf8:	00003097          	auipc	ra,0x3
    80002bfc:	19a080e7          	jalr	410(ra) # 80005d92 <panic>
    80002c00:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c02:	40dc                	lw	a5,4(s1)
    80002c04:	0047d79b          	srlw	a5,a5,0x4
    80002c08:	00014597          	auipc	a1,0x14
    80002c0c:	2385a583          	lw	a1,568(a1) # 80016e40 <sb+0x18>
    80002c10:	9dbd                	addw	a1,a1,a5
    80002c12:	4088                	lw	a0,0(s1)
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	77a080e7          	jalr	1914(ra) # 8000238e <bread>
    80002c1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1e:	05850593          	add	a1,a0,88
    80002c22:	40dc                	lw	a5,4(s1)
    80002c24:	8bbd                	and	a5,a5,15
    80002c26:	079a                	sll	a5,a5,0x6
    80002c28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c2a:	00059783          	lh	a5,0(a1)
    80002c2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c32:	00259783          	lh	a5,2(a1)
    80002c36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c3a:	00459783          	lh	a5,4(a1)
    80002c3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c42:	00659783          	lh	a5,6(a1)
    80002c46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c4a:	459c                	lw	a5,8(a1)
    80002c4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c4e:	03400613          	li	a2,52
    80002c52:	05b1                	add	a1,a1,12
    80002c54:	05048513          	add	a0,s1,80
    80002c58:	ffffd097          	auipc	ra,0xffffd
    80002c5c:	57e080e7          	jalr	1406(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c60:	854a                	mv	a0,s2
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	85c080e7          	jalr	-1956(ra) # 800024be <brelse>
    ip->valid = 1;
    80002c6a:	4785                	li	a5,1
    80002c6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c6e:	04449783          	lh	a5,68(s1)
    80002c72:	c399                	beqz	a5,80002c78 <ilock+0xb6>
    80002c74:	6902                	ld	s2,0(sp)
    80002c76:	b7bd                	j	80002be4 <ilock+0x22>
      panic("ilock: no type");
    80002c78:	00006517          	auipc	a0,0x6
    80002c7c:	82850513          	add	a0,a0,-2008 # 800084a0 <etext+0x4a0>
    80002c80:	00003097          	auipc	ra,0x3
    80002c84:	112080e7          	jalr	274(ra) # 80005d92 <panic>

0000000080002c88 <iunlock>:
{
    80002c88:	1101                	add	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	e426                	sd	s1,8(sp)
    80002c90:	e04a                	sd	s2,0(sp)
    80002c92:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c94:	c905                	beqz	a0,80002cc4 <iunlock+0x3c>
    80002c96:	84aa                	mv	s1,a0
    80002c98:	01050913          	add	s2,a0,16
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	c82080e7          	jalr	-894(ra) # 80003920 <holdingsleep>
    80002ca6:	cd19                	beqz	a0,80002cc4 <iunlock+0x3c>
    80002ca8:	449c                	lw	a5,8(s1)
    80002caa:	00f05d63          	blez	a5,80002cc4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cae:	854a                	mv	a0,s2
    80002cb0:	00001097          	auipc	ra,0x1
    80002cb4:	c2c080e7          	jalr	-980(ra) # 800038dc <releasesleep>
}
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6902                	ld	s2,0(sp)
    80002cc0:	6105                	add	sp,sp,32
    80002cc2:	8082                	ret
    panic("iunlock");
    80002cc4:	00005517          	auipc	a0,0x5
    80002cc8:	7ec50513          	add	a0,a0,2028 # 800084b0 <etext+0x4b0>
    80002ccc:	00003097          	auipc	ra,0x3
    80002cd0:	0c6080e7          	jalr	198(ra) # 80005d92 <panic>

0000000080002cd4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd4:	7179                	add	sp,sp,-48
    80002cd6:	f406                	sd	ra,40(sp)
    80002cd8:	f022                	sd	s0,32(sp)
    80002cda:	ec26                	sd	s1,24(sp)
    80002cdc:	e84a                	sd	s2,16(sp)
    80002cde:	e44e                	sd	s3,8(sp)
    80002ce0:	1800                	add	s0,sp,48
    80002ce2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce4:	05050493          	add	s1,a0,80
    80002ce8:	08050913          	add	s2,a0,128
    80002cec:	a021                	j	80002cf4 <itrunc+0x20>
    80002cee:	0491                	add	s1,s1,4
    80002cf0:	01248d63          	beq	s1,s2,80002d0a <itrunc+0x36>
    if(ip->addrs[i]){
    80002cf4:	408c                	lw	a1,0(s1)
    80002cf6:	dde5                	beqz	a1,80002cee <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002cf8:	0009a503          	lw	a0,0(s3)
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	8d6080e7          	jalr	-1834(ra) # 800025d2 <bfree>
      ip->addrs[i] = 0;
    80002d04:	0004a023          	sw	zero,0(s1)
    80002d08:	b7dd                	j	80002cee <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d0a:	0809a583          	lw	a1,128(s3)
    80002d0e:	ed99                	bnez	a1,80002d2c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d14:	854e                	mv	a0,s3
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	de0080e7          	jalr	-544(ra) # 80002af6 <iupdate>
}
    80002d1e:	70a2                	ld	ra,40(sp)
    80002d20:	7402                	ld	s0,32(sp)
    80002d22:	64e2                	ld	s1,24(sp)
    80002d24:	6942                	ld	s2,16(sp)
    80002d26:	69a2                	ld	s3,8(sp)
    80002d28:	6145                	add	sp,sp,48
    80002d2a:	8082                	ret
    80002d2c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d2e:	0009a503          	lw	a0,0(s3)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	65c080e7          	jalr	1628(ra) # 8000238e <bread>
    80002d3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d3c:	05850493          	add	s1,a0,88
    80002d40:	45850913          	add	s2,a0,1112
    80002d44:	a021                	j	80002d4c <itrunc+0x78>
    80002d46:	0491                	add	s1,s1,4
    80002d48:	01248b63          	beq	s1,s2,80002d5e <itrunc+0x8a>
      if(a[j])
    80002d4c:	408c                	lw	a1,0(s1)
    80002d4e:	dde5                	beqz	a1,80002d46 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	87e080e7          	jalr	-1922(ra) # 800025d2 <bfree>
    80002d5c:	b7ed                	j	80002d46 <itrunc+0x72>
    brelse(bp);
    80002d5e:	8552                	mv	a0,s4
    80002d60:	fffff097          	auipc	ra,0xfffff
    80002d64:	75e080e7          	jalr	1886(ra) # 800024be <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d68:	0809a583          	lw	a1,128(s3)
    80002d6c:	0009a503          	lw	a0,0(s3)
    80002d70:	00000097          	auipc	ra,0x0
    80002d74:	862080e7          	jalr	-1950(ra) # 800025d2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d78:	0809a023          	sw	zero,128(s3)
    80002d7c:	6a02                	ld	s4,0(sp)
    80002d7e:	bf49                	j	80002d10 <itrunc+0x3c>

0000000080002d80 <iput>:
{
    80002d80:	1101                	add	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	1000                	add	s0,sp,32
    80002d8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d8c:	00014517          	auipc	a0,0x14
    80002d90:	0bc50513          	add	a0,a0,188 # 80016e48 <itable>
    80002d94:	00003097          	auipc	ra,0x3
    80002d98:	578080e7          	jalr	1400(ra) # 8000630c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d9c:	4498                	lw	a4,8(s1)
    80002d9e:	4785                	li	a5,1
    80002da0:	02f70263          	beq	a4,a5,80002dc4 <iput+0x44>
  ip->ref--;
    80002da4:	449c                	lw	a5,8(s1)
    80002da6:	37fd                	addw	a5,a5,-1
    80002da8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002daa:	00014517          	auipc	a0,0x14
    80002dae:	09e50513          	add	a0,a0,158 # 80016e48 <itable>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	60e080e7          	jalr	1550(ra) # 800063c0 <release>
}
    80002dba:	60e2                	ld	ra,24(sp)
    80002dbc:	6442                	ld	s0,16(sp)
    80002dbe:	64a2                	ld	s1,8(sp)
    80002dc0:	6105                	add	sp,sp,32
    80002dc2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc4:	40bc                	lw	a5,64(s1)
    80002dc6:	dff9                	beqz	a5,80002da4 <iput+0x24>
    80002dc8:	04a49783          	lh	a5,74(s1)
    80002dcc:	ffe1                	bnez	a5,80002da4 <iput+0x24>
    80002dce:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002dd0:	01048913          	add	s2,s1,16
    80002dd4:	854a                	mv	a0,s2
    80002dd6:	00001097          	auipc	ra,0x1
    80002dda:	ab0080e7          	jalr	-1360(ra) # 80003886 <acquiresleep>
    release(&itable.lock);
    80002dde:	00014517          	auipc	a0,0x14
    80002de2:	06a50513          	add	a0,a0,106 # 80016e48 <itable>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	5da080e7          	jalr	1498(ra) # 800063c0 <release>
    itrunc(ip);
    80002dee:	8526                	mv	a0,s1
    80002df0:	00000097          	auipc	ra,0x0
    80002df4:	ee4080e7          	jalr	-284(ra) # 80002cd4 <itrunc>
    ip->type = 0;
    80002df8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dfc:	8526                	mv	a0,s1
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	cf8080e7          	jalr	-776(ra) # 80002af6 <iupdate>
    ip->valid = 0;
    80002e06:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	00001097          	auipc	ra,0x1
    80002e10:	ad0080e7          	jalr	-1328(ra) # 800038dc <releasesleep>
    acquire(&itable.lock);
    80002e14:	00014517          	auipc	a0,0x14
    80002e18:	03450513          	add	a0,a0,52 # 80016e48 <itable>
    80002e1c:	00003097          	auipc	ra,0x3
    80002e20:	4f0080e7          	jalr	1264(ra) # 8000630c <acquire>
    80002e24:	6902                	ld	s2,0(sp)
    80002e26:	bfbd                	j	80002da4 <iput+0x24>

0000000080002e28 <iunlockput>:
{
    80002e28:	1101                	add	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	1000                	add	s0,sp,32
    80002e32:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	e54080e7          	jalr	-428(ra) # 80002c88 <iunlock>
  iput(ip);
    80002e3c:	8526                	mv	a0,s1
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	f42080e7          	jalr	-190(ra) # 80002d80 <iput>
}
    80002e46:	60e2                	ld	ra,24(sp)
    80002e48:	6442                	ld	s0,16(sp)
    80002e4a:	64a2                	ld	s1,8(sp)
    80002e4c:	6105                	add	sp,sp,32
    80002e4e:	8082                	ret

0000000080002e50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e50:	1141                	add	sp,sp,-16
    80002e52:	e422                	sd	s0,8(sp)
    80002e54:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002e56:	411c                	lw	a5,0(a0)
    80002e58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e5a:	415c                	lw	a5,4(a0)
    80002e5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e5e:	04451783          	lh	a5,68(a0)
    80002e62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e66:	04a51783          	lh	a5,74(a0)
    80002e6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e6e:	04c56783          	lwu	a5,76(a0)
    80002e72:	e99c                	sd	a5,16(a1)
}
    80002e74:	6422                	ld	s0,8(sp)
    80002e76:	0141                	add	sp,sp,16
    80002e78:	8082                	ret

0000000080002e7a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7a:	457c                	lw	a5,76(a0)
    80002e7c:	10d7e563          	bltu	a5,a3,80002f86 <readi+0x10c>
{
    80002e80:	7159                	add	sp,sp,-112
    80002e82:	f486                	sd	ra,104(sp)
    80002e84:	f0a2                	sd	s0,96(sp)
    80002e86:	eca6                	sd	s1,88(sp)
    80002e88:	e0d2                	sd	s4,64(sp)
    80002e8a:	fc56                	sd	s5,56(sp)
    80002e8c:	f85a                	sd	s6,48(sp)
    80002e8e:	f45e                	sd	s7,40(sp)
    80002e90:	1880                	add	s0,sp,112
    80002e92:	8b2a                	mv	s6,a0
    80002e94:	8bae                	mv	s7,a1
    80002e96:	8a32                	mv	s4,a2
    80002e98:	84b6                	mv	s1,a3
    80002e9a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e9c:	9f35                	addw	a4,a4,a3
    return 0;
    80002e9e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea0:	0cd76a63          	bltu	a4,a3,80002f74 <readi+0xfa>
    80002ea4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002ea6:	00e7f463          	bgeu	a5,a4,80002eae <readi+0x34>
    n = ip->size - off;
    80002eaa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eae:	0a0a8963          	beqz	s5,80002f60 <readi+0xe6>
    80002eb2:	e8ca                	sd	s2,80(sp)
    80002eb4:	f062                	sd	s8,32(sp)
    80002eb6:	ec66                	sd	s9,24(sp)
    80002eb8:	e86a                	sd	s10,16(sp)
    80002eba:	e46e                	sd	s11,8(sp)
    80002ebc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ebe:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ec2:	5c7d                	li	s8,-1
    80002ec4:	a82d                	j	80002efe <readi+0x84>
    80002ec6:	020d1d93          	sll	s11,s10,0x20
    80002eca:	020ddd93          	srl	s11,s11,0x20
    80002ece:	05890613          	add	a2,s2,88
    80002ed2:	86ee                	mv	a3,s11
    80002ed4:	963a                	add	a2,a2,a4
    80002ed6:	85d2                	mv	a1,s4
    80002ed8:	855e                	mv	a0,s7
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	ae2080e7          	jalr	-1310(ra) # 800019bc <either_copyout>
    80002ee2:	05850d63          	beq	a0,s8,80002f3c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ee6:	854a                	mv	a0,s2
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	5d6080e7          	jalr	1494(ra) # 800024be <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef0:	013d09bb          	addw	s3,s10,s3
    80002ef4:	009d04bb          	addw	s1,s10,s1
    80002ef8:	9a6e                	add	s4,s4,s11
    80002efa:	0559fd63          	bgeu	s3,s5,80002f54 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80002efe:	00a4d59b          	srlw	a1,s1,0xa
    80002f02:	855a                	mv	a0,s6
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	88e080e7          	jalr	-1906(ra) # 80002792 <bmap>
    80002f0c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f10:	c9b1                	beqz	a1,80002f64 <readi+0xea>
    bp = bread(ip->dev, addr);
    80002f12:	000b2503          	lw	a0,0(s6)
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	478080e7          	jalr	1144(ra) # 8000238e <bread>
    80002f1e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f20:	3ff4f713          	and	a4,s1,1023
    80002f24:	40ec87bb          	subw	a5,s9,a4
    80002f28:	413a86bb          	subw	a3,s5,s3
    80002f2c:	8d3e                	mv	s10,a5
    80002f2e:	2781                	sext.w	a5,a5
    80002f30:	0006861b          	sext.w	a2,a3
    80002f34:	f8f679e3          	bgeu	a2,a5,80002ec6 <readi+0x4c>
    80002f38:	8d36                	mv	s10,a3
    80002f3a:	b771                	j	80002ec6 <readi+0x4c>
      brelse(bp);
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	580080e7          	jalr	1408(ra) # 800024be <brelse>
      tot = -1;
    80002f46:	59fd                	li	s3,-1
      break;
    80002f48:	6946                	ld	s2,80(sp)
    80002f4a:	7c02                	ld	s8,32(sp)
    80002f4c:	6ce2                	ld	s9,24(sp)
    80002f4e:	6d42                	ld	s10,16(sp)
    80002f50:	6da2                	ld	s11,8(sp)
    80002f52:	a831                	j	80002f6e <readi+0xf4>
    80002f54:	6946                	ld	s2,80(sp)
    80002f56:	7c02                	ld	s8,32(sp)
    80002f58:	6ce2                	ld	s9,24(sp)
    80002f5a:	6d42                	ld	s10,16(sp)
    80002f5c:	6da2                	ld	s11,8(sp)
    80002f5e:	a801                	j	80002f6e <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f60:	89d6                	mv	s3,s5
    80002f62:	a031                	j	80002f6e <readi+0xf4>
    80002f64:	6946                	ld	s2,80(sp)
    80002f66:	7c02                	ld	s8,32(sp)
    80002f68:	6ce2                	ld	s9,24(sp)
    80002f6a:	6d42                	ld	s10,16(sp)
    80002f6c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f6e:	0009851b          	sext.w	a0,s3
    80002f72:	69a6                	ld	s3,72(sp)
}
    80002f74:	70a6                	ld	ra,104(sp)
    80002f76:	7406                	ld	s0,96(sp)
    80002f78:	64e6                	ld	s1,88(sp)
    80002f7a:	6a06                	ld	s4,64(sp)
    80002f7c:	7ae2                	ld	s5,56(sp)
    80002f7e:	7b42                	ld	s6,48(sp)
    80002f80:	7ba2                	ld	s7,40(sp)
    80002f82:	6165                	add	sp,sp,112
    80002f84:	8082                	ret
    return 0;
    80002f86:	4501                	li	a0,0
}
    80002f88:	8082                	ret

0000000080002f8a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f8a:	457c                	lw	a5,76(a0)
    80002f8c:	10d7ee63          	bltu	a5,a3,800030a8 <writei+0x11e>
{
    80002f90:	7159                	add	sp,sp,-112
    80002f92:	f486                	sd	ra,104(sp)
    80002f94:	f0a2                	sd	s0,96(sp)
    80002f96:	e8ca                	sd	s2,80(sp)
    80002f98:	e0d2                	sd	s4,64(sp)
    80002f9a:	fc56                	sd	s5,56(sp)
    80002f9c:	f85a                	sd	s6,48(sp)
    80002f9e:	f45e                	sd	s7,40(sp)
    80002fa0:	1880                	add	s0,sp,112
    80002fa2:	8aaa                	mv	s5,a0
    80002fa4:	8bae                	mv	s7,a1
    80002fa6:	8a32                	mv	s4,a2
    80002fa8:	8936                	mv	s2,a3
    80002faa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fac:	00e687bb          	addw	a5,a3,a4
    80002fb0:	0ed7ee63          	bltu	a5,a3,800030ac <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fb4:	00043737          	lui	a4,0x43
    80002fb8:	0ef76c63          	bltu	a4,a5,800030b0 <writei+0x126>
    80002fbc:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fbe:	0c0b0d63          	beqz	s6,80003098 <writei+0x10e>
    80002fc2:	eca6                	sd	s1,88(sp)
    80002fc4:	f062                	sd	s8,32(sp)
    80002fc6:	ec66                	sd	s9,24(sp)
    80002fc8:	e86a                	sd	s10,16(sp)
    80002fca:	e46e                	sd	s11,8(sp)
    80002fcc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fce:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fd2:	5c7d                	li	s8,-1
    80002fd4:	a091                	j	80003018 <writei+0x8e>
    80002fd6:	020d1d93          	sll	s11,s10,0x20
    80002fda:	020ddd93          	srl	s11,s11,0x20
    80002fde:	05848513          	add	a0,s1,88
    80002fe2:	86ee                	mv	a3,s11
    80002fe4:	8652                	mv	a2,s4
    80002fe6:	85de                	mv	a1,s7
    80002fe8:	953a                	add	a0,a0,a4
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	a28080e7          	jalr	-1496(ra) # 80001a12 <either_copyin>
    80002ff2:	07850263          	beq	a0,s8,80003056 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ff6:	8526                	mv	a0,s1
    80002ff8:	00000097          	auipc	ra,0x0
    80002ffc:	770080e7          	jalr	1904(ra) # 80003768 <log_write>
    brelse(bp);
    80003000:	8526                	mv	a0,s1
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	4bc080e7          	jalr	1212(ra) # 800024be <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000300a:	013d09bb          	addw	s3,s10,s3
    8000300e:	012d093b          	addw	s2,s10,s2
    80003012:	9a6e                	add	s4,s4,s11
    80003014:	0569f663          	bgeu	s3,s6,80003060 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003018:	00a9559b          	srlw	a1,s2,0xa
    8000301c:	8556                	mv	a0,s5
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	774080e7          	jalr	1908(ra) # 80002792 <bmap>
    80003026:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000302a:	c99d                	beqz	a1,80003060 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000302c:	000aa503          	lw	a0,0(s5)
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	35e080e7          	jalr	862(ra) # 8000238e <bread>
    80003038:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000303a:	3ff97713          	and	a4,s2,1023
    8000303e:	40ec87bb          	subw	a5,s9,a4
    80003042:	413b06bb          	subw	a3,s6,s3
    80003046:	8d3e                	mv	s10,a5
    80003048:	2781                	sext.w	a5,a5
    8000304a:	0006861b          	sext.w	a2,a3
    8000304e:	f8f674e3          	bgeu	a2,a5,80002fd6 <writei+0x4c>
    80003052:	8d36                	mv	s10,a3
    80003054:	b749                	j	80002fd6 <writei+0x4c>
      brelse(bp);
    80003056:	8526                	mv	a0,s1
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	466080e7          	jalr	1126(ra) # 800024be <brelse>
  }

  if(off > ip->size)
    80003060:	04caa783          	lw	a5,76(s5)
    80003064:	0327fc63          	bgeu	a5,s2,8000309c <writei+0x112>
    ip->size = off;
    80003068:	052aa623          	sw	s2,76(s5)
    8000306c:	64e6                	ld	s1,88(sp)
    8000306e:	7c02                	ld	s8,32(sp)
    80003070:	6ce2                	ld	s9,24(sp)
    80003072:	6d42                	ld	s10,16(sp)
    80003074:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003076:	8556                	mv	a0,s5
    80003078:	00000097          	auipc	ra,0x0
    8000307c:	a7e080e7          	jalr	-1410(ra) # 80002af6 <iupdate>

  return tot;
    80003080:	0009851b          	sext.w	a0,s3
    80003084:	69a6                	ld	s3,72(sp)
}
    80003086:	70a6                	ld	ra,104(sp)
    80003088:	7406                	ld	s0,96(sp)
    8000308a:	6946                	ld	s2,80(sp)
    8000308c:	6a06                	ld	s4,64(sp)
    8000308e:	7ae2                	ld	s5,56(sp)
    80003090:	7b42                	ld	s6,48(sp)
    80003092:	7ba2                	ld	s7,40(sp)
    80003094:	6165                	add	sp,sp,112
    80003096:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003098:	89da                	mv	s3,s6
    8000309a:	bff1                	j	80003076 <writei+0xec>
    8000309c:	64e6                	ld	s1,88(sp)
    8000309e:	7c02                	ld	s8,32(sp)
    800030a0:	6ce2                	ld	s9,24(sp)
    800030a2:	6d42                	ld	s10,16(sp)
    800030a4:	6da2                	ld	s11,8(sp)
    800030a6:	bfc1                	j	80003076 <writei+0xec>
    return -1;
    800030a8:	557d                	li	a0,-1
}
    800030aa:	8082                	ret
    return -1;
    800030ac:	557d                	li	a0,-1
    800030ae:	bfe1                	j	80003086 <writei+0xfc>
    return -1;
    800030b0:	557d                	li	a0,-1
    800030b2:	bfd1                	j	80003086 <writei+0xfc>

00000000800030b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030b4:	1141                	add	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030bc:	4639                	li	a2,14
    800030be:	ffffd097          	auipc	ra,0xffffd
    800030c2:	18c080e7          	jalr	396(ra) # 8000024a <strncmp>
}
    800030c6:	60a2                	ld	ra,8(sp)
    800030c8:	6402                	ld	s0,0(sp)
    800030ca:	0141                	add	sp,sp,16
    800030cc:	8082                	ret

00000000800030ce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ce:	7139                	add	sp,sp,-64
    800030d0:	fc06                	sd	ra,56(sp)
    800030d2:	f822                	sd	s0,48(sp)
    800030d4:	f426                	sd	s1,40(sp)
    800030d6:	f04a                	sd	s2,32(sp)
    800030d8:	ec4e                	sd	s3,24(sp)
    800030da:	e852                	sd	s4,16(sp)
    800030dc:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030de:	04451703          	lh	a4,68(a0)
    800030e2:	4785                	li	a5,1
    800030e4:	00f71a63          	bne	a4,a5,800030f8 <dirlookup+0x2a>
    800030e8:	892a                	mv	s2,a0
    800030ea:	89ae                	mv	s3,a1
    800030ec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ee:	457c                	lw	a5,76(a0)
    800030f0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030f2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f4:	e79d                	bnez	a5,80003122 <dirlookup+0x54>
    800030f6:	a8a5                	j	8000316e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f8:	00005517          	auipc	a0,0x5
    800030fc:	3c050513          	add	a0,a0,960 # 800084b8 <etext+0x4b8>
    80003100:	00003097          	auipc	ra,0x3
    80003104:	c92080e7          	jalr	-878(ra) # 80005d92 <panic>
      panic("dirlookup read");
    80003108:	00005517          	auipc	a0,0x5
    8000310c:	3c850513          	add	a0,a0,968 # 800084d0 <etext+0x4d0>
    80003110:	00003097          	auipc	ra,0x3
    80003114:	c82080e7          	jalr	-894(ra) # 80005d92 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003118:	24c1                	addw	s1,s1,16
    8000311a:	04c92783          	lw	a5,76(s2)
    8000311e:	04f4f763          	bgeu	s1,a5,8000316c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003122:	4741                	li	a4,16
    80003124:	86a6                	mv	a3,s1
    80003126:	fc040613          	add	a2,s0,-64
    8000312a:	4581                	li	a1,0
    8000312c:	854a                	mv	a0,s2
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	d4c080e7          	jalr	-692(ra) # 80002e7a <readi>
    80003136:	47c1                	li	a5,16
    80003138:	fcf518e3          	bne	a0,a5,80003108 <dirlookup+0x3a>
    if(de.inum == 0)
    8000313c:	fc045783          	lhu	a5,-64(s0)
    80003140:	dfe1                	beqz	a5,80003118 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003142:	fc240593          	add	a1,s0,-62
    80003146:	854e                	mv	a0,s3
    80003148:	00000097          	auipc	ra,0x0
    8000314c:	f6c080e7          	jalr	-148(ra) # 800030b4 <namecmp>
    80003150:	f561                	bnez	a0,80003118 <dirlookup+0x4a>
      if(poff)
    80003152:	000a0463          	beqz	s4,8000315a <dirlookup+0x8c>
        *poff = off;
    80003156:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000315a:	fc045583          	lhu	a1,-64(s0)
    8000315e:	00092503          	lw	a0,0(s2)
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	720080e7          	jalr	1824(ra) # 80002882 <iget>
    8000316a:	a011                	j	8000316e <dirlookup+0xa0>
  return 0;
    8000316c:	4501                	li	a0,0
}
    8000316e:	70e2                	ld	ra,56(sp)
    80003170:	7442                	ld	s0,48(sp)
    80003172:	74a2                	ld	s1,40(sp)
    80003174:	7902                	ld	s2,32(sp)
    80003176:	69e2                	ld	s3,24(sp)
    80003178:	6a42                	ld	s4,16(sp)
    8000317a:	6121                	add	sp,sp,64
    8000317c:	8082                	ret

000000008000317e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000317e:	711d                	add	sp,sp,-96
    80003180:	ec86                	sd	ra,88(sp)
    80003182:	e8a2                	sd	s0,80(sp)
    80003184:	e4a6                	sd	s1,72(sp)
    80003186:	e0ca                	sd	s2,64(sp)
    80003188:	fc4e                	sd	s3,56(sp)
    8000318a:	f852                	sd	s4,48(sp)
    8000318c:	f456                	sd	s5,40(sp)
    8000318e:	f05a                	sd	s6,32(sp)
    80003190:	ec5e                	sd	s7,24(sp)
    80003192:	e862                	sd	s8,16(sp)
    80003194:	e466                	sd	s9,8(sp)
    80003196:	1080                	add	s0,sp,96
    80003198:	84aa                	mv	s1,a0
    8000319a:	8b2e                	mv	s6,a1
    8000319c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000319e:	00054703          	lbu	a4,0(a0)
    800031a2:	02f00793          	li	a5,47
    800031a6:	02f70263          	beq	a4,a5,800031ca <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031aa:	ffffe097          	auipc	ra,0xffffe
    800031ae:	d5c080e7          	jalr	-676(ra) # 80000f06 <myproc>
    800031b2:	15053503          	ld	a0,336(a0)
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	9ce080e7          	jalr	-1586(ra) # 80002b84 <idup>
    800031be:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031c0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031c4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031c6:	4b85                	li	s7,1
    800031c8:	a875                	j	80003284 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031ca:	4585                	li	a1,1
    800031cc:	4505                	li	a0,1
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	6b4080e7          	jalr	1716(ra) # 80002882 <iget>
    800031d6:	8a2a                	mv	s4,a0
    800031d8:	b7e5                	j	800031c0 <namex+0x42>
      iunlockput(ip);
    800031da:	8552                	mv	a0,s4
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	c4c080e7          	jalr	-948(ra) # 80002e28 <iunlockput>
      return 0;
    800031e4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e6:	8552                	mv	a0,s4
    800031e8:	60e6                	ld	ra,88(sp)
    800031ea:	6446                	ld	s0,80(sp)
    800031ec:	64a6                	ld	s1,72(sp)
    800031ee:	6906                	ld	s2,64(sp)
    800031f0:	79e2                	ld	s3,56(sp)
    800031f2:	7a42                	ld	s4,48(sp)
    800031f4:	7aa2                	ld	s5,40(sp)
    800031f6:	7b02                	ld	s6,32(sp)
    800031f8:	6be2                	ld	s7,24(sp)
    800031fa:	6c42                	ld	s8,16(sp)
    800031fc:	6ca2                	ld	s9,8(sp)
    800031fe:	6125                	add	sp,sp,96
    80003200:	8082                	ret
      iunlock(ip);
    80003202:	8552                	mv	a0,s4
    80003204:	00000097          	auipc	ra,0x0
    80003208:	a84080e7          	jalr	-1404(ra) # 80002c88 <iunlock>
      return ip;
    8000320c:	bfe9                	j	800031e6 <namex+0x68>
      iunlockput(ip);
    8000320e:	8552                	mv	a0,s4
    80003210:	00000097          	auipc	ra,0x0
    80003214:	c18080e7          	jalr	-1000(ra) # 80002e28 <iunlockput>
      return 0;
    80003218:	8a4e                	mv	s4,s3
    8000321a:	b7f1                	j	800031e6 <namex+0x68>
  len = path - s;
    8000321c:	40998633          	sub	a2,s3,s1
    80003220:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003224:	099c5863          	bge	s8,s9,800032b4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003228:	4639                	li	a2,14
    8000322a:	85a6                	mv	a1,s1
    8000322c:	8556                	mv	a0,s5
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	fa8080e7          	jalr	-88(ra) # 800001d6 <memmove>
    80003236:	84ce                	mv	s1,s3
  while(*path == '/')
    80003238:	0004c783          	lbu	a5,0(s1)
    8000323c:	01279763          	bne	a5,s2,8000324a <namex+0xcc>
    path++;
    80003240:	0485                	add	s1,s1,1
  while(*path == '/')
    80003242:	0004c783          	lbu	a5,0(s1)
    80003246:	ff278de3          	beq	a5,s2,80003240 <namex+0xc2>
    ilock(ip);
    8000324a:	8552                	mv	a0,s4
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	976080e7          	jalr	-1674(ra) # 80002bc2 <ilock>
    if(ip->type != T_DIR){
    80003254:	044a1783          	lh	a5,68(s4)
    80003258:	f97791e3          	bne	a5,s7,800031da <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000325c:	000b0563          	beqz	s6,80003266 <namex+0xe8>
    80003260:	0004c783          	lbu	a5,0(s1)
    80003264:	dfd9                	beqz	a5,80003202 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003266:	4601                	li	a2,0
    80003268:	85d6                	mv	a1,s5
    8000326a:	8552                	mv	a0,s4
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	e62080e7          	jalr	-414(ra) # 800030ce <dirlookup>
    80003274:	89aa                	mv	s3,a0
    80003276:	dd41                	beqz	a0,8000320e <namex+0x90>
    iunlockput(ip);
    80003278:	8552                	mv	a0,s4
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	bae080e7          	jalr	-1106(ra) # 80002e28 <iunlockput>
    ip = next;
    80003282:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003284:	0004c783          	lbu	a5,0(s1)
    80003288:	01279763          	bne	a5,s2,80003296 <namex+0x118>
    path++;
    8000328c:	0485                	add	s1,s1,1
  while(*path == '/')
    8000328e:	0004c783          	lbu	a5,0(s1)
    80003292:	ff278de3          	beq	a5,s2,8000328c <namex+0x10e>
  if(*path == 0)
    80003296:	cb9d                	beqz	a5,800032cc <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003298:	0004c783          	lbu	a5,0(s1)
    8000329c:	89a6                	mv	s3,s1
  len = path - s;
    8000329e:	4c81                	li	s9,0
    800032a0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032a2:	01278963          	beq	a5,s2,800032b4 <namex+0x136>
    800032a6:	dbbd                	beqz	a5,8000321c <namex+0x9e>
    path++;
    800032a8:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800032aa:	0009c783          	lbu	a5,0(s3)
    800032ae:	ff279ce3          	bne	a5,s2,800032a6 <namex+0x128>
    800032b2:	b7ad                	j	8000321c <namex+0x9e>
    memmove(name, s, len);
    800032b4:	2601                	sext.w	a2,a2
    800032b6:	85a6                	mv	a1,s1
    800032b8:	8556                	mv	a0,s5
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	f1c080e7          	jalr	-228(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032c2:	9cd6                	add	s9,s9,s5
    800032c4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032c8:	84ce                	mv	s1,s3
    800032ca:	b7bd                	j	80003238 <namex+0xba>
  if(nameiparent){
    800032cc:	f00b0de3          	beqz	s6,800031e6 <namex+0x68>
    iput(ip);
    800032d0:	8552                	mv	a0,s4
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	aae080e7          	jalr	-1362(ra) # 80002d80 <iput>
    return 0;
    800032da:	4a01                	li	s4,0
    800032dc:	b729                	j	800031e6 <namex+0x68>

00000000800032de <dirlink>:
{
    800032de:	7139                	add	sp,sp,-64
    800032e0:	fc06                	sd	ra,56(sp)
    800032e2:	f822                	sd	s0,48(sp)
    800032e4:	f04a                	sd	s2,32(sp)
    800032e6:	ec4e                	sd	s3,24(sp)
    800032e8:	e852                	sd	s4,16(sp)
    800032ea:	0080                	add	s0,sp,64
    800032ec:	892a                	mv	s2,a0
    800032ee:	8a2e                	mv	s4,a1
    800032f0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032f2:	4601                	li	a2,0
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	dda080e7          	jalr	-550(ra) # 800030ce <dirlookup>
    800032fc:	ed25                	bnez	a0,80003374 <dirlink+0x96>
    800032fe:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003300:	04c92483          	lw	s1,76(s2)
    80003304:	c49d                	beqz	s1,80003332 <dirlink+0x54>
    80003306:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003308:	4741                	li	a4,16
    8000330a:	86a6                	mv	a3,s1
    8000330c:	fc040613          	add	a2,s0,-64
    80003310:	4581                	li	a1,0
    80003312:	854a                	mv	a0,s2
    80003314:	00000097          	auipc	ra,0x0
    80003318:	b66080e7          	jalr	-1178(ra) # 80002e7a <readi>
    8000331c:	47c1                	li	a5,16
    8000331e:	06f51163          	bne	a0,a5,80003380 <dirlink+0xa2>
    if(de.inum == 0)
    80003322:	fc045783          	lhu	a5,-64(s0)
    80003326:	c791                	beqz	a5,80003332 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003328:	24c1                	addw	s1,s1,16
    8000332a:	04c92783          	lw	a5,76(s2)
    8000332e:	fcf4ede3          	bltu	s1,a5,80003308 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003332:	4639                	li	a2,14
    80003334:	85d2                	mv	a1,s4
    80003336:	fc240513          	add	a0,s0,-62
    8000333a:	ffffd097          	auipc	ra,0xffffd
    8000333e:	f46080e7          	jalr	-186(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003342:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003346:	4741                	li	a4,16
    80003348:	86a6                	mv	a3,s1
    8000334a:	fc040613          	add	a2,s0,-64
    8000334e:	4581                	li	a1,0
    80003350:	854a                	mv	a0,s2
    80003352:	00000097          	auipc	ra,0x0
    80003356:	c38080e7          	jalr	-968(ra) # 80002f8a <writei>
    8000335a:	1541                	add	a0,a0,-16
    8000335c:	00a03533          	snez	a0,a0
    80003360:	40a00533          	neg	a0,a0
    80003364:	74a2                	ld	s1,40(sp)
}
    80003366:	70e2                	ld	ra,56(sp)
    80003368:	7442                	ld	s0,48(sp)
    8000336a:	7902                	ld	s2,32(sp)
    8000336c:	69e2                	ld	s3,24(sp)
    8000336e:	6a42                	ld	s4,16(sp)
    80003370:	6121                	add	sp,sp,64
    80003372:	8082                	ret
    iput(ip);
    80003374:	00000097          	auipc	ra,0x0
    80003378:	a0c080e7          	jalr	-1524(ra) # 80002d80 <iput>
    return -1;
    8000337c:	557d                	li	a0,-1
    8000337e:	b7e5                	j	80003366 <dirlink+0x88>
      panic("dirlink read");
    80003380:	00005517          	auipc	a0,0x5
    80003384:	16050513          	add	a0,a0,352 # 800084e0 <etext+0x4e0>
    80003388:	00003097          	auipc	ra,0x3
    8000338c:	a0a080e7          	jalr	-1526(ra) # 80005d92 <panic>

0000000080003390 <namei>:

struct inode*
namei(char *path)
{
    80003390:	1101                	add	sp,sp,-32
    80003392:	ec06                	sd	ra,24(sp)
    80003394:	e822                	sd	s0,16(sp)
    80003396:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003398:	fe040613          	add	a2,s0,-32
    8000339c:	4581                	li	a1,0
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	de0080e7          	jalr	-544(ra) # 8000317e <namex>
}
    800033a6:	60e2                	ld	ra,24(sp)
    800033a8:	6442                	ld	s0,16(sp)
    800033aa:	6105                	add	sp,sp,32
    800033ac:	8082                	ret

00000000800033ae <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033ae:	1141                	add	sp,sp,-16
    800033b0:	e406                	sd	ra,8(sp)
    800033b2:	e022                	sd	s0,0(sp)
    800033b4:	0800                	add	s0,sp,16
    800033b6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033b8:	4585                	li	a1,1
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	dc4080e7          	jalr	-572(ra) # 8000317e <namex>
}
    800033c2:	60a2                	ld	ra,8(sp)
    800033c4:	6402                	ld	s0,0(sp)
    800033c6:	0141                	add	sp,sp,16
    800033c8:	8082                	ret

00000000800033ca <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033ca:	1101                	add	sp,sp,-32
    800033cc:	ec06                	sd	ra,24(sp)
    800033ce:	e822                	sd	s0,16(sp)
    800033d0:	e426                	sd	s1,8(sp)
    800033d2:	e04a                	sd	s2,0(sp)
    800033d4:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033d6:	00015917          	auipc	s2,0x15
    800033da:	51a90913          	add	s2,s2,1306 # 800188f0 <log>
    800033de:	01892583          	lw	a1,24(s2)
    800033e2:	02892503          	lw	a0,40(s2)
    800033e6:	fffff097          	auipc	ra,0xfffff
    800033ea:	fa8080e7          	jalr	-88(ra) # 8000238e <bread>
    800033ee:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033f0:	02c92603          	lw	a2,44(s2)
    800033f4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033f6:	00c05f63          	blez	a2,80003414 <write_head+0x4a>
    800033fa:	00015717          	auipc	a4,0x15
    800033fe:	52670713          	add	a4,a4,1318 # 80018920 <log+0x30>
    80003402:	87aa                	mv	a5,a0
    80003404:	060a                	sll	a2,a2,0x2
    80003406:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003408:	4314                	lw	a3,0(a4)
    8000340a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000340c:	0711                	add	a4,a4,4
    8000340e:	0791                	add	a5,a5,4
    80003410:	fec79ce3          	bne	a5,a2,80003408 <write_head+0x3e>
  }
  bwrite(buf);
    80003414:	8526                	mv	a0,s1
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	06a080e7          	jalr	106(ra) # 80002480 <bwrite>
  brelse(buf);
    8000341e:	8526                	mv	a0,s1
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	09e080e7          	jalr	158(ra) # 800024be <brelse>
}
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6902                	ld	s2,0(sp)
    80003430:	6105                	add	sp,sp,32
    80003432:	8082                	ret

0000000080003434 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003434:	00015797          	auipc	a5,0x15
    80003438:	4e87a783          	lw	a5,1256(a5) # 8001891c <log+0x2c>
    8000343c:	0af05d63          	blez	a5,800034f6 <install_trans+0xc2>
{
    80003440:	7139                	add	sp,sp,-64
    80003442:	fc06                	sd	ra,56(sp)
    80003444:	f822                	sd	s0,48(sp)
    80003446:	f426                	sd	s1,40(sp)
    80003448:	f04a                	sd	s2,32(sp)
    8000344a:	ec4e                	sd	s3,24(sp)
    8000344c:	e852                	sd	s4,16(sp)
    8000344e:	e456                	sd	s5,8(sp)
    80003450:	e05a                	sd	s6,0(sp)
    80003452:	0080                	add	s0,sp,64
    80003454:	8b2a                	mv	s6,a0
    80003456:	00015a97          	auipc	s5,0x15
    8000345a:	4caa8a93          	add	s5,s5,1226 # 80018920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003460:	00015997          	auipc	s3,0x15
    80003464:	49098993          	add	s3,s3,1168 # 800188f0 <log>
    80003468:	a00d                	j	8000348a <install_trans+0x56>
    brelse(lbuf);
    8000346a:	854a                	mv	a0,s2
    8000346c:	fffff097          	auipc	ra,0xfffff
    80003470:	052080e7          	jalr	82(ra) # 800024be <brelse>
    brelse(dbuf);
    80003474:	8526                	mv	a0,s1
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	048080e7          	jalr	72(ra) # 800024be <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347e:	2a05                	addw	s4,s4,1
    80003480:	0a91                	add	s5,s5,4
    80003482:	02c9a783          	lw	a5,44(s3)
    80003486:	04fa5e63          	bge	s4,a5,800034e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000348a:	0189a583          	lw	a1,24(s3)
    8000348e:	014585bb          	addw	a1,a1,s4
    80003492:	2585                	addw	a1,a1,1
    80003494:	0289a503          	lw	a0,40(s3)
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	ef6080e7          	jalr	-266(ra) # 8000238e <bread>
    800034a0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034a2:	000aa583          	lw	a1,0(s5)
    800034a6:	0289a503          	lw	a0,40(s3)
    800034aa:	fffff097          	auipc	ra,0xfffff
    800034ae:	ee4080e7          	jalr	-284(ra) # 8000238e <bread>
    800034b2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b4:	40000613          	li	a2,1024
    800034b8:	05890593          	add	a1,s2,88
    800034bc:	05850513          	add	a0,a0,88
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	d16080e7          	jalr	-746(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c8:	8526                	mv	a0,s1
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	fb6080e7          	jalr	-74(ra) # 80002480 <bwrite>
    if(recovering == 0)
    800034d2:	f80b1ce3          	bnez	s6,8000346a <install_trans+0x36>
      bunpin(dbuf);
    800034d6:	8526                	mv	a0,s1
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	0be080e7          	jalr	190(ra) # 80002596 <bunpin>
    800034e0:	b769                	j	8000346a <install_trans+0x36>
}
    800034e2:	70e2                	ld	ra,56(sp)
    800034e4:	7442                	ld	s0,48(sp)
    800034e6:	74a2                	ld	s1,40(sp)
    800034e8:	7902                	ld	s2,32(sp)
    800034ea:	69e2                	ld	s3,24(sp)
    800034ec:	6a42                	ld	s4,16(sp)
    800034ee:	6aa2                	ld	s5,8(sp)
    800034f0:	6b02                	ld	s6,0(sp)
    800034f2:	6121                	add	sp,sp,64
    800034f4:	8082                	ret
    800034f6:	8082                	ret

00000000800034f8 <initlog>:
{
    800034f8:	7179                	add	sp,sp,-48
    800034fa:	f406                	sd	ra,40(sp)
    800034fc:	f022                	sd	s0,32(sp)
    800034fe:	ec26                	sd	s1,24(sp)
    80003500:	e84a                	sd	s2,16(sp)
    80003502:	e44e                	sd	s3,8(sp)
    80003504:	1800                	add	s0,sp,48
    80003506:	892a                	mv	s2,a0
    80003508:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000350a:	00015497          	auipc	s1,0x15
    8000350e:	3e648493          	add	s1,s1,998 # 800188f0 <log>
    80003512:	00005597          	auipc	a1,0x5
    80003516:	fde58593          	add	a1,a1,-34 # 800084f0 <etext+0x4f0>
    8000351a:	8526                	mv	a0,s1
    8000351c:	00003097          	auipc	ra,0x3
    80003520:	d60080e7          	jalr	-672(ra) # 8000627c <initlock>
  log.start = sb->logstart;
    80003524:	0149a583          	lw	a1,20(s3)
    80003528:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000352a:	0109a783          	lw	a5,16(s3)
    8000352e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003530:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003534:	854a                	mv	a0,s2
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	e58080e7          	jalr	-424(ra) # 8000238e <bread>
  log.lh.n = lh->n;
    8000353e:	4d30                	lw	a2,88(a0)
    80003540:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	00c05f63          	blez	a2,80003560 <initlog+0x68>
    80003546:	87aa                	mv	a5,a0
    80003548:	00015717          	auipc	a4,0x15
    8000354c:	3d870713          	add	a4,a4,984 # 80018920 <log+0x30>
    80003550:	060a                	sll	a2,a2,0x2
    80003552:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003554:	4ff4                	lw	a3,92(a5)
    80003556:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003558:	0791                	add	a5,a5,4
    8000355a:	0711                	add	a4,a4,4
    8000355c:	fec79ce3          	bne	a5,a2,80003554 <initlog+0x5c>
  brelse(buf);
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	f5e080e7          	jalr	-162(ra) # 800024be <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003568:	4505                	li	a0,1
    8000356a:	00000097          	auipc	ra,0x0
    8000356e:	eca080e7          	jalr	-310(ra) # 80003434 <install_trans>
  log.lh.n = 0;
    80003572:	00015797          	auipc	a5,0x15
    80003576:	3a07a523          	sw	zero,938(a5) # 8001891c <log+0x2c>
  write_head(); // clear the log
    8000357a:	00000097          	auipc	ra,0x0
    8000357e:	e50080e7          	jalr	-432(ra) # 800033ca <write_head>
}
    80003582:	70a2                	ld	ra,40(sp)
    80003584:	7402                	ld	s0,32(sp)
    80003586:	64e2                	ld	s1,24(sp)
    80003588:	6942                	ld	s2,16(sp)
    8000358a:	69a2                	ld	s3,8(sp)
    8000358c:	6145                	add	sp,sp,48
    8000358e:	8082                	ret

0000000080003590 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003590:	1101                	add	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	e426                	sd	s1,8(sp)
    80003598:	e04a                	sd	s2,0(sp)
    8000359a:	1000                	add	s0,sp,32
  acquire(&log.lock);
    8000359c:	00015517          	auipc	a0,0x15
    800035a0:	35450513          	add	a0,a0,852 # 800188f0 <log>
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	d68080e7          	jalr	-664(ra) # 8000630c <acquire>
  while(1){
    if(log.committing){
    800035ac:	00015497          	auipc	s1,0x15
    800035b0:	34448493          	add	s1,s1,836 # 800188f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b4:	4979                	li	s2,30
    800035b6:	a039                	j	800035c4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035b8:	85a6                	mv	a1,s1
    800035ba:	8526                	mv	a0,s1
    800035bc:	ffffe097          	auipc	ra,0xffffe
    800035c0:	ff8080e7          	jalr	-8(ra) # 800015b4 <sleep>
    if(log.committing){
    800035c4:	50dc                	lw	a5,36(s1)
    800035c6:	fbed                	bnez	a5,800035b8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c8:	5098                	lw	a4,32(s1)
    800035ca:	2705                	addw	a4,a4,1
    800035cc:	0027179b          	sllw	a5,a4,0x2
    800035d0:	9fb9                	addw	a5,a5,a4
    800035d2:	0017979b          	sllw	a5,a5,0x1
    800035d6:	54d4                	lw	a3,44(s1)
    800035d8:	9fb5                	addw	a5,a5,a3
    800035da:	00f95963          	bge	s2,a5,800035ec <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035de:	85a6                	mv	a1,s1
    800035e0:	8526                	mv	a0,s1
    800035e2:	ffffe097          	auipc	ra,0xffffe
    800035e6:	fd2080e7          	jalr	-46(ra) # 800015b4 <sleep>
    800035ea:	bfe9                	j	800035c4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035ec:	00015517          	auipc	a0,0x15
    800035f0:	30450513          	add	a0,a0,772 # 800188f0 <log>
    800035f4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800035f6:	00003097          	auipc	ra,0x3
    800035fa:	dca080e7          	jalr	-566(ra) # 800063c0 <release>
      break;
    }
  }
}
    800035fe:	60e2                	ld	ra,24(sp)
    80003600:	6442                	ld	s0,16(sp)
    80003602:	64a2                	ld	s1,8(sp)
    80003604:	6902                	ld	s2,0(sp)
    80003606:	6105                	add	sp,sp,32
    80003608:	8082                	ret

000000008000360a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000360a:	7139                	add	sp,sp,-64
    8000360c:	fc06                	sd	ra,56(sp)
    8000360e:	f822                	sd	s0,48(sp)
    80003610:	f426                	sd	s1,40(sp)
    80003612:	f04a                	sd	s2,32(sp)
    80003614:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003616:	00015497          	auipc	s1,0x15
    8000361a:	2da48493          	add	s1,s1,730 # 800188f0 <log>
    8000361e:	8526                	mv	a0,s1
    80003620:	00003097          	auipc	ra,0x3
    80003624:	cec080e7          	jalr	-788(ra) # 8000630c <acquire>
  log.outstanding -= 1;
    80003628:	509c                	lw	a5,32(s1)
    8000362a:	37fd                	addw	a5,a5,-1
    8000362c:	0007891b          	sext.w	s2,a5
    80003630:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003632:	50dc                	lw	a5,36(s1)
    80003634:	e7b9                	bnez	a5,80003682 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003636:	06091163          	bnez	s2,80003698 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000363a:	00015497          	auipc	s1,0x15
    8000363e:	2b648493          	add	s1,s1,694 # 800188f0 <log>
    80003642:	4785                	li	a5,1
    80003644:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003646:	8526                	mv	a0,s1
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	d78080e7          	jalr	-648(ra) # 800063c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003650:	54dc                	lw	a5,44(s1)
    80003652:	06f04763          	bgtz	a5,800036c0 <end_op+0xb6>
    acquire(&log.lock);
    80003656:	00015497          	auipc	s1,0x15
    8000365a:	29a48493          	add	s1,s1,666 # 800188f0 <log>
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	cac080e7          	jalr	-852(ra) # 8000630c <acquire>
    log.committing = 0;
    80003668:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000366c:	8526                	mv	a0,s1
    8000366e:	ffffe097          	auipc	ra,0xffffe
    80003672:	faa080e7          	jalr	-86(ra) # 80001618 <wakeup>
    release(&log.lock);
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	d48080e7          	jalr	-696(ra) # 800063c0 <release>
}
    80003680:	a815                	j	800036b4 <end_op+0xaa>
    80003682:	ec4e                	sd	s3,24(sp)
    80003684:	e852                	sd	s4,16(sp)
    80003686:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003688:	00005517          	auipc	a0,0x5
    8000368c:	e7050513          	add	a0,a0,-400 # 800084f8 <etext+0x4f8>
    80003690:	00002097          	auipc	ra,0x2
    80003694:	702080e7          	jalr	1794(ra) # 80005d92 <panic>
    wakeup(&log);
    80003698:	00015497          	auipc	s1,0x15
    8000369c:	25848493          	add	s1,s1,600 # 800188f0 <log>
    800036a0:	8526                	mv	a0,s1
    800036a2:	ffffe097          	auipc	ra,0xffffe
    800036a6:	f76080e7          	jalr	-138(ra) # 80001618 <wakeup>
  release(&log.lock);
    800036aa:	8526                	mv	a0,s1
    800036ac:	00003097          	auipc	ra,0x3
    800036b0:	d14080e7          	jalr	-748(ra) # 800063c0 <release>
}
    800036b4:	70e2                	ld	ra,56(sp)
    800036b6:	7442                	ld	s0,48(sp)
    800036b8:	74a2                	ld	s1,40(sp)
    800036ba:	7902                	ld	s2,32(sp)
    800036bc:	6121                	add	sp,sp,64
    800036be:	8082                	ret
    800036c0:	ec4e                	sd	s3,24(sp)
    800036c2:	e852                	sd	s4,16(sp)
    800036c4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c6:	00015a97          	auipc	s5,0x15
    800036ca:	25aa8a93          	add	s5,s5,602 # 80018920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ce:	00015a17          	auipc	s4,0x15
    800036d2:	222a0a13          	add	s4,s4,546 # 800188f0 <log>
    800036d6:	018a2583          	lw	a1,24(s4)
    800036da:	012585bb          	addw	a1,a1,s2
    800036de:	2585                	addw	a1,a1,1
    800036e0:	028a2503          	lw	a0,40(s4)
    800036e4:	fffff097          	auipc	ra,0xfffff
    800036e8:	caa080e7          	jalr	-854(ra) # 8000238e <bread>
    800036ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036ee:	000aa583          	lw	a1,0(s5)
    800036f2:	028a2503          	lw	a0,40(s4)
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	c98080e7          	jalr	-872(ra) # 8000238e <bread>
    800036fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003700:	40000613          	li	a2,1024
    80003704:	05850593          	add	a1,a0,88
    80003708:	05848513          	add	a0,s1,88
    8000370c:	ffffd097          	auipc	ra,0xffffd
    80003710:	aca080e7          	jalr	-1334(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003714:	8526                	mv	a0,s1
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	d6a080e7          	jalr	-662(ra) # 80002480 <bwrite>
    brelse(from);
    8000371e:	854e                	mv	a0,s3
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	d9e080e7          	jalr	-610(ra) # 800024be <brelse>
    brelse(to);
    80003728:	8526                	mv	a0,s1
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	d94080e7          	jalr	-620(ra) # 800024be <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003732:	2905                	addw	s2,s2,1
    80003734:	0a91                	add	s5,s5,4
    80003736:	02ca2783          	lw	a5,44(s4)
    8000373a:	f8f94ee3          	blt	s2,a5,800036d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	c8c080e7          	jalr	-884(ra) # 800033ca <write_head>
    install_trans(0); // Now install writes to home locations
    80003746:	4501                	li	a0,0
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	cec080e7          	jalr	-788(ra) # 80003434 <install_trans>
    log.lh.n = 0;
    80003750:	00015797          	auipc	a5,0x15
    80003754:	1c07a623          	sw	zero,460(a5) # 8001891c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	c72080e7          	jalr	-910(ra) # 800033ca <write_head>
    80003760:	69e2                	ld	s3,24(sp)
    80003762:	6a42                	ld	s4,16(sp)
    80003764:	6aa2                	ld	s5,8(sp)
    80003766:	bdc5                	j	80003656 <end_op+0x4c>

0000000080003768 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003768:	1101                	add	sp,sp,-32
    8000376a:	ec06                	sd	ra,24(sp)
    8000376c:	e822                	sd	s0,16(sp)
    8000376e:	e426                	sd	s1,8(sp)
    80003770:	e04a                	sd	s2,0(sp)
    80003772:	1000                	add	s0,sp,32
    80003774:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003776:	00015917          	auipc	s2,0x15
    8000377a:	17a90913          	add	s2,s2,378 # 800188f0 <log>
    8000377e:	854a                	mv	a0,s2
    80003780:	00003097          	auipc	ra,0x3
    80003784:	b8c080e7          	jalr	-1140(ra) # 8000630c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003788:	02c92603          	lw	a2,44(s2)
    8000378c:	47f5                	li	a5,29
    8000378e:	06c7c563          	blt	a5,a2,800037f8 <log_write+0x90>
    80003792:	00015797          	auipc	a5,0x15
    80003796:	17a7a783          	lw	a5,378(a5) # 8001890c <log+0x1c>
    8000379a:	37fd                	addw	a5,a5,-1
    8000379c:	04f65e63          	bge	a2,a5,800037f8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037a0:	00015797          	auipc	a5,0x15
    800037a4:	1707a783          	lw	a5,368(a5) # 80018910 <log+0x20>
    800037a8:	06f05063          	blez	a5,80003808 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ac:	4781                	li	a5,0
    800037ae:	06c05563          	blez	a2,80003818 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b2:	44cc                	lw	a1,12(s1)
    800037b4:	00015717          	auipc	a4,0x15
    800037b8:	16c70713          	add	a4,a4,364 # 80018920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037bc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037be:	4314                	lw	a3,0(a4)
    800037c0:	04b68c63          	beq	a3,a1,80003818 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	2785                	addw	a5,a5,1
    800037c6:	0711                	add	a4,a4,4
    800037c8:	fef61be3          	bne	a2,a5,800037be <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037cc:	0621                	add	a2,a2,8
    800037ce:	060a                	sll	a2,a2,0x2
    800037d0:	00015797          	auipc	a5,0x15
    800037d4:	12078793          	add	a5,a5,288 # 800188f0 <log>
    800037d8:	97b2                	add	a5,a5,a2
    800037da:	44d8                	lw	a4,12(s1)
    800037dc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037de:	8526                	mv	a0,s1
    800037e0:	fffff097          	auipc	ra,0xfffff
    800037e4:	d7a080e7          	jalr	-646(ra) # 8000255a <bpin>
    log.lh.n++;
    800037e8:	00015717          	auipc	a4,0x15
    800037ec:	10870713          	add	a4,a4,264 # 800188f0 <log>
    800037f0:	575c                	lw	a5,44(a4)
    800037f2:	2785                	addw	a5,a5,1
    800037f4:	d75c                	sw	a5,44(a4)
    800037f6:	a82d                	j	80003830 <log_write+0xc8>
    panic("too big a transaction");
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	d1050513          	add	a0,a0,-752 # 80008508 <etext+0x508>
    80003800:	00002097          	auipc	ra,0x2
    80003804:	592080e7          	jalr	1426(ra) # 80005d92 <panic>
    panic("log_write outside of trans");
    80003808:	00005517          	auipc	a0,0x5
    8000380c:	d1850513          	add	a0,a0,-744 # 80008520 <etext+0x520>
    80003810:	00002097          	auipc	ra,0x2
    80003814:	582080e7          	jalr	1410(ra) # 80005d92 <panic>
  log.lh.block[i] = b->blockno;
    80003818:	00878693          	add	a3,a5,8
    8000381c:	068a                	sll	a3,a3,0x2
    8000381e:	00015717          	auipc	a4,0x15
    80003822:	0d270713          	add	a4,a4,210 # 800188f0 <log>
    80003826:	9736                	add	a4,a4,a3
    80003828:	44d4                	lw	a3,12(s1)
    8000382a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000382c:	faf609e3          	beq	a2,a5,800037de <log_write+0x76>
  }
  release(&log.lock);
    80003830:	00015517          	auipc	a0,0x15
    80003834:	0c050513          	add	a0,a0,192 # 800188f0 <log>
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	b88080e7          	jalr	-1144(ra) # 800063c0 <release>
}
    80003840:	60e2                	ld	ra,24(sp)
    80003842:	6442                	ld	s0,16(sp)
    80003844:	64a2                	ld	s1,8(sp)
    80003846:	6902                	ld	s2,0(sp)
    80003848:	6105                	add	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000384c:	1101                	add	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	e426                	sd	s1,8(sp)
    80003854:	e04a                	sd	s2,0(sp)
    80003856:	1000                	add	s0,sp,32
    80003858:	84aa                	mv	s1,a0
    8000385a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000385c:	00005597          	auipc	a1,0x5
    80003860:	ce458593          	add	a1,a1,-796 # 80008540 <etext+0x540>
    80003864:	0521                	add	a0,a0,8
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	a16080e7          	jalr	-1514(ra) # 8000627c <initlock>
  lk->name = name;
    8000386e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003872:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003876:	0204a423          	sw	zero,40(s1)
}
    8000387a:	60e2                	ld	ra,24(sp)
    8000387c:	6442                	ld	s0,16(sp)
    8000387e:	64a2                	ld	s1,8(sp)
    80003880:	6902                	ld	s2,0(sp)
    80003882:	6105                	add	sp,sp,32
    80003884:	8082                	ret

0000000080003886 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003886:	1101                	add	sp,sp,-32
    80003888:	ec06                	sd	ra,24(sp)
    8000388a:	e822                	sd	s0,16(sp)
    8000388c:	e426                	sd	s1,8(sp)
    8000388e:	e04a                	sd	s2,0(sp)
    80003890:	1000                	add	s0,sp,32
    80003892:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003894:	00850913          	add	s2,a0,8
    80003898:	854a                	mv	a0,s2
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	a72080e7          	jalr	-1422(ra) # 8000630c <acquire>
  while (lk->locked) {
    800038a2:	409c                	lw	a5,0(s1)
    800038a4:	cb89                	beqz	a5,800038b6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038a6:	85ca                	mv	a1,s2
    800038a8:	8526                	mv	a0,s1
    800038aa:	ffffe097          	auipc	ra,0xffffe
    800038ae:	d0a080e7          	jalr	-758(ra) # 800015b4 <sleep>
  while (lk->locked) {
    800038b2:	409c                	lw	a5,0(s1)
    800038b4:	fbed                	bnez	a5,800038a6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038b6:	4785                	li	a5,1
    800038b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ba:	ffffd097          	auipc	ra,0xffffd
    800038be:	64c080e7          	jalr	1612(ra) # 80000f06 <myproc>
    800038c2:	591c                	lw	a5,48(a0)
    800038c4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038c6:	854a                	mv	a0,s2
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	af8080e7          	jalr	-1288(ra) # 800063c0 <release>
}
    800038d0:	60e2                	ld	ra,24(sp)
    800038d2:	6442                	ld	s0,16(sp)
    800038d4:	64a2                	ld	s1,8(sp)
    800038d6:	6902                	ld	s2,0(sp)
    800038d8:	6105                	add	sp,sp,32
    800038da:	8082                	ret

00000000800038dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038dc:	1101                	add	sp,sp,-32
    800038de:	ec06                	sd	ra,24(sp)
    800038e0:	e822                	sd	s0,16(sp)
    800038e2:	e426                	sd	s1,8(sp)
    800038e4:	e04a                	sd	s2,0(sp)
    800038e6:	1000                	add	s0,sp,32
    800038e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ea:	00850913          	add	s2,a0,8
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	a1c080e7          	jalr	-1508(ra) # 8000630c <acquire>
  lk->locked = 0;
    800038f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038fc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003900:	8526                	mv	a0,s1
    80003902:	ffffe097          	auipc	ra,0xffffe
    80003906:	d16080e7          	jalr	-746(ra) # 80001618 <wakeup>
  release(&lk->lk);
    8000390a:	854a                	mv	a0,s2
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	ab4080e7          	jalr	-1356(ra) # 800063c0 <release>
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    8000391c:	6105                	add	sp,sp,32
    8000391e:	8082                	ret

0000000080003920 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003920:	7179                	add	sp,sp,-48
    80003922:	f406                	sd	ra,40(sp)
    80003924:	f022                	sd	s0,32(sp)
    80003926:	ec26                	sd	s1,24(sp)
    80003928:	e84a                	sd	s2,16(sp)
    8000392a:	1800                	add	s0,sp,48
    8000392c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000392e:	00850913          	add	s2,a0,8
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	9d8080e7          	jalr	-1576(ra) # 8000630c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393c:	409c                	lw	a5,0(s1)
    8000393e:	ef91                	bnez	a5,8000395a <holdingsleep+0x3a>
    80003940:	4481                	li	s1,0
  release(&lk->lk);
    80003942:	854a                	mv	a0,s2
    80003944:	00003097          	auipc	ra,0x3
    80003948:	a7c080e7          	jalr	-1412(ra) # 800063c0 <release>
  return r;
}
    8000394c:	8526                	mv	a0,s1
    8000394e:	70a2                	ld	ra,40(sp)
    80003950:	7402                	ld	s0,32(sp)
    80003952:	64e2                	ld	s1,24(sp)
    80003954:	6942                	ld	s2,16(sp)
    80003956:	6145                	add	sp,sp,48
    80003958:	8082                	ret
    8000395a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000395c:	0284a983          	lw	s3,40(s1)
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	5a6080e7          	jalr	1446(ra) # 80000f06 <myproc>
    80003968:	5904                	lw	s1,48(a0)
    8000396a:	413484b3          	sub	s1,s1,s3
    8000396e:	0014b493          	seqz	s1,s1
    80003972:	69a2                	ld	s3,8(sp)
    80003974:	b7f9                	j	80003942 <holdingsleep+0x22>

0000000080003976 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003976:	1141                	add	sp,sp,-16
    80003978:	e406                	sd	ra,8(sp)
    8000397a:	e022                	sd	s0,0(sp)
    8000397c:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000397e:	00005597          	auipc	a1,0x5
    80003982:	bd258593          	add	a1,a1,-1070 # 80008550 <etext+0x550>
    80003986:	00015517          	auipc	a0,0x15
    8000398a:	0b250513          	add	a0,a0,178 # 80018a38 <ftable>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	8ee080e7          	jalr	-1810(ra) # 8000627c <initlock>
}
    80003996:	60a2                	ld	ra,8(sp)
    80003998:	6402                	ld	s0,0(sp)
    8000399a:	0141                	add	sp,sp,16
    8000399c:	8082                	ret

000000008000399e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000399e:	1101                	add	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039a8:	00015517          	auipc	a0,0x15
    800039ac:	09050513          	add	a0,a0,144 # 80018a38 <ftable>
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	95c080e7          	jalr	-1700(ra) # 8000630c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b8:	00015497          	auipc	s1,0x15
    800039bc:	09848493          	add	s1,s1,152 # 80018a50 <ftable+0x18>
    800039c0:	00016717          	auipc	a4,0x16
    800039c4:	03070713          	add	a4,a4,48 # 800199f0 <disk>
    if(f->ref == 0){
    800039c8:	40dc                	lw	a5,4(s1)
    800039ca:	cf99                	beqz	a5,800039e8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039cc:	02848493          	add	s1,s1,40
    800039d0:	fee49ce3          	bne	s1,a4,800039c8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039d4:	00015517          	auipc	a0,0x15
    800039d8:	06450513          	add	a0,a0,100 # 80018a38 <ftable>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	9e4080e7          	jalr	-1564(ra) # 800063c0 <release>
  return 0;
    800039e4:	4481                	li	s1,0
    800039e6:	a819                	j	800039fc <filealloc+0x5e>
      f->ref = 1;
    800039e8:	4785                	li	a5,1
    800039ea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039ec:	00015517          	auipc	a0,0x15
    800039f0:	04c50513          	add	a0,a0,76 # 80018a38 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	9cc080e7          	jalr	-1588(ra) # 800063c0 <release>
}
    800039fc:	8526                	mv	a0,s1
    800039fe:	60e2                	ld	ra,24(sp)
    80003a00:	6442                	ld	s0,16(sp)
    80003a02:	64a2                	ld	s1,8(sp)
    80003a04:	6105                	add	sp,sp,32
    80003a06:	8082                	ret

0000000080003a08 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a08:	1101                	add	sp,sp,-32
    80003a0a:	ec06                	sd	ra,24(sp)
    80003a0c:	e822                	sd	s0,16(sp)
    80003a0e:	e426                	sd	s1,8(sp)
    80003a10:	1000                	add	s0,sp,32
    80003a12:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a14:	00015517          	auipc	a0,0x15
    80003a18:	02450513          	add	a0,a0,36 # 80018a38 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	8f0080e7          	jalr	-1808(ra) # 8000630c <acquire>
  if(f->ref < 1)
    80003a24:	40dc                	lw	a5,4(s1)
    80003a26:	02f05263          	blez	a5,80003a4a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a2a:	2785                	addw	a5,a5,1
    80003a2c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a2e:	00015517          	auipc	a0,0x15
    80003a32:	00a50513          	add	a0,a0,10 # 80018a38 <ftable>
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	98a080e7          	jalr	-1654(ra) # 800063c0 <release>
  return f;
}
    80003a3e:	8526                	mv	a0,s1
    80003a40:	60e2                	ld	ra,24(sp)
    80003a42:	6442                	ld	s0,16(sp)
    80003a44:	64a2                	ld	s1,8(sp)
    80003a46:	6105                	add	sp,sp,32
    80003a48:	8082                	ret
    panic("filedup");
    80003a4a:	00005517          	auipc	a0,0x5
    80003a4e:	b0e50513          	add	a0,a0,-1266 # 80008558 <etext+0x558>
    80003a52:	00002097          	auipc	ra,0x2
    80003a56:	340080e7          	jalr	832(ra) # 80005d92 <panic>

0000000080003a5a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a5a:	7139                	add	sp,sp,-64
    80003a5c:	fc06                	sd	ra,56(sp)
    80003a5e:	f822                	sd	s0,48(sp)
    80003a60:	f426                	sd	s1,40(sp)
    80003a62:	0080                	add	s0,sp,64
    80003a64:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a66:	00015517          	auipc	a0,0x15
    80003a6a:	fd250513          	add	a0,a0,-46 # 80018a38 <ftable>
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	89e080e7          	jalr	-1890(ra) # 8000630c <acquire>
  if(f->ref < 1)
    80003a76:	40dc                	lw	a5,4(s1)
    80003a78:	04f05c63          	blez	a5,80003ad0 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003a7c:	37fd                	addw	a5,a5,-1
    80003a7e:	0007871b          	sext.w	a4,a5
    80003a82:	c0dc                	sw	a5,4(s1)
    80003a84:	06e04263          	bgtz	a4,80003ae8 <fileclose+0x8e>
    80003a88:	f04a                	sd	s2,32(sp)
    80003a8a:	ec4e                	sd	s3,24(sp)
    80003a8c:	e852                	sd	s4,16(sp)
    80003a8e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a90:	0004a903          	lw	s2,0(s1)
    80003a94:	0094ca83          	lbu	s5,9(s1)
    80003a98:	0104ba03          	ld	s4,16(s1)
    80003a9c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aa0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aa4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aa8:	00015517          	auipc	a0,0x15
    80003aac:	f9050513          	add	a0,a0,-112 # 80018a38 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	910080e7          	jalr	-1776(ra) # 800063c0 <release>

  if(ff.type == FD_PIPE){
    80003ab8:	4785                	li	a5,1
    80003aba:	04f90463          	beq	s2,a5,80003b02 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003abe:	3979                	addw	s2,s2,-2
    80003ac0:	4785                	li	a5,1
    80003ac2:	0527fb63          	bgeu	a5,s2,80003b18 <fileclose+0xbe>
    80003ac6:	7902                	ld	s2,32(sp)
    80003ac8:	69e2                	ld	s3,24(sp)
    80003aca:	6a42                	ld	s4,16(sp)
    80003acc:	6aa2                	ld	s5,8(sp)
    80003ace:	a02d                	j	80003af8 <fileclose+0x9e>
    80003ad0:	f04a                	sd	s2,32(sp)
    80003ad2:	ec4e                	sd	s3,24(sp)
    80003ad4:	e852                	sd	s4,16(sp)
    80003ad6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ad8:	00005517          	auipc	a0,0x5
    80003adc:	a8850513          	add	a0,a0,-1400 # 80008560 <etext+0x560>
    80003ae0:	00002097          	auipc	ra,0x2
    80003ae4:	2b2080e7          	jalr	690(ra) # 80005d92 <panic>
    release(&ftable.lock);
    80003ae8:	00015517          	auipc	a0,0x15
    80003aec:	f5050513          	add	a0,a0,-176 # 80018a38 <ftable>
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	8d0080e7          	jalr	-1840(ra) # 800063c0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003af8:	70e2                	ld	ra,56(sp)
    80003afa:	7442                	ld	s0,48(sp)
    80003afc:	74a2                	ld	s1,40(sp)
    80003afe:	6121                	add	sp,sp,64
    80003b00:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b02:	85d6                	mv	a1,s5
    80003b04:	8552                	mv	a0,s4
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	3a2080e7          	jalr	930(ra) # 80003ea8 <pipeclose>
    80003b0e:	7902                	ld	s2,32(sp)
    80003b10:	69e2                	ld	s3,24(sp)
    80003b12:	6a42                	ld	s4,16(sp)
    80003b14:	6aa2                	ld	s5,8(sp)
    80003b16:	b7cd                	j	80003af8 <fileclose+0x9e>
    begin_op();
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	a78080e7          	jalr	-1416(ra) # 80003590 <begin_op>
    iput(ff.ip);
    80003b20:	854e                	mv	a0,s3
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	25e080e7          	jalr	606(ra) # 80002d80 <iput>
    end_op();
    80003b2a:	00000097          	auipc	ra,0x0
    80003b2e:	ae0080e7          	jalr	-1312(ra) # 8000360a <end_op>
    80003b32:	7902                	ld	s2,32(sp)
    80003b34:	69e2                	ld	s3,24(sp)
    80003b36:	6a42                	ld	s4,16(sp)
    80003b38:	6aa2                	ld	s5,8(sp)
    80003b3a:	bf7d                	j	80003af8 <fileclose+0x9e>

0000000080003b3c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b3c:	715d                	add	sp,sp,-80
    80003b3e:	e486                	sd	ra,72(sp)
    80003b40:	e0a2                	sd	s0,64(sp)
    80003b42:	fc26                	sd	s1,56(sp)
    80003b44:	f44e                	sd	s3,40(sp)
    80003b46:	0880                	add	s0,sp,80
    80003b48:	84aa                	mv	s1,a0
    80003b4a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	3ba080e7          	jalr	954(ra) # 80000f06 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b54:	409c                	lw	a5,0(s1)
    80003b56:	37f9                	addw	a5,a5,-2
    80003b58:	4705                	li	a4,1
    80003b5a:	04f76863          	bltu	a4,a5,80003baa <filestat+0x6e>
    80003b5e:	f84a                	sd	s2,48(sp)
    80003b60:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b62:	6c88                	ld	a0,24(s1)
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	05e080e7          	jalr	94(ra) # 80002bc2 <ilock>
    stati(f->ip, &st);
    80003b6c:	fb840593          	add	a1,s0,-72
    80003b70:	6c88                	ld	a0,24(s1)
    80003b72:	fffff097          	auipc	ra,0xfffff
    80003b76:	2de080e7          	jalr	734(ra) # 80002e50 <stati>
    iunlock(f->ip);
    80003b7a:	6c88                	ld	a0,24(s1)
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	10c080e7          	jalr	268(ra) # 80002c88 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b84:	46e1                	li	a3,24
    80003b86:	fb840613          	add	a2,s0,-72
    80003b8a:	85ce                	mv	a1,s3
    80003b8c:	05093503          	ld	a0,80(s2)
    80003b90:	ffffd097          	auipc	ra,0xffffd
    80003b94:	fbc080e7          	jalr	-68(ra) # 80000b4c <copyout>
    80003b98:	41f5551b          	sraw	a0,a0,0x1f
    80003b9c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b9e:	60a6                	ld	ra,72(sp)
    80003ba0:	6406                	ld	s0,64(sp)
    80003ba2:	74e2                	ld	s1,56(sp)
    80003ba4:	79a2                	ld	s3,40(sp)
    80003ba6:	6161                	add	sp,sp,80
    80003ba8:	8082                	ret
  return -1;
    80003baa:	557d                	li	a0,-1
    80003bac:	bfcd                	j	80003b9e <filestat+0x62>

0000000080003bae <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bae:	7179                	add	sp,sp,-48
    80003bb0:	f406                	sd	ra,40(sp)
    80003bb2:	f022                	sd	s0,32(sp)
    80003bb4:	e84a                	sd	s2,16(sp)
    80003bb6:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bb8:	00854783          	lbu	a5,8(a0)
    80003bbc:	cbc5                	beqz	a5,80003c6c <fileread+0xbe>
    80003bbe:	ec26                	sd	s1,24(sp)
    80003bc0:	e44e                	sd	s3,8(sp)
    80003bc2:	84aa                	mv	s1,a0
    80003bc4:	89ae                	mv	s3,a1
    80003bc6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc8:	411c                	lw	a5,0(a0)
    80003bca:	4705                	li	a4,1
    80003bcc:	04e78963          	beq	a5,a4,80003c1e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bd0:	470d                	li	a4,3
    80003bd2:	04e78f63          	beq	a5,a4,80003c30 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd6:	4709                	li	a4,2
    80003bd8:	08e79263          	bne	a5,a4,80003c5c <fileread+0xae>
    ilock(f->ip);
    80003bdc:	6d08                	ld	a0,24(a0)
    80003bde:	fffff097          	auipc	ra,0xfffff
    80003be2:	fe4080e7          	jalr	-28(ra) # 80002bc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be6:	874a                	mv	a4,s2
    80003be8:	5094                	lw	a3,32(s1)
    80003bea:	864e                	mv	a2,s3
    80003bec:	4585                	li	a1,1
    80003bee:	6c88                	ld	a0,24(s1)
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	28a080e7          	jalr	650(ra) # 80002e7a <readi>
    80003bf8:	892a                	mv	s2,a0
    80003bfa:	00a05563          	blez	a0,80003c04 <fileread+0x56>
      f->off += r;
    80003bfe:	509c                	lw	a5,32(s1)
    80003c00:	9fa9                	addw	a5,a5,a0
    80003c02:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	082080e7          	jalr	130(ra) # 80002c88 <iunlock>
    80003c0e:	64e2                	ld	s1,24(sp)
    80003c10:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c12:	854a                	mv	a0,s2
    80003c14:	70a2                	ld	ra,40(sp)
    80003c16:	7402                	ld	s0,32(sp)
    80003c18:	6942                	ld	s2,16(sp)
    80003c1a:	6145                	add	sp,sp,48
    80003c1c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c1e:	6908                	ld	a0,16(a0)
    80003c20:	00000097          	auipc	ra,0x0
    80003c24:	400080e7          	jalr	1024(ra) # 80004020 <piperead>
    80003c28:	892a                	mv	s2,a0
    80003c2a:	64e2                	ld	s1,24(sp)
    80003c2c:	69a2                	ld	s3,8(sp)
    80003c2e:	b7d5                	j	80003c12 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c30:	02451783          	lh	a5,36(a0)
    80003c34:	03079693          	sll	a3,a5,0x30
    80003c38:	92c1                	srl	a3,a3,0x30
    80003c3a:	4725                	li	a4,9
    80003c3c:	02d76a63          	bltu	a4,a3,80003c70 <fileread+0xc2>
    80003c40:	0792                	sll	a5,a5,0x4
    80003c42:	00015717          	auipc	a4,0x15
    80003c46:	d5670713          	add	a4,a4,-682 # 80018998 <devsw>
    80003c4a:	97ba                	add	a5,a5,a4
    80003c4c:	639c                	ld	a5,0(a5)
    80003c4e:	c78d                	beqz	a5,80003c78 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c50:	4505                	li	a0,1
    80003c52:	9782                	jalr	a5
    80003c54:	892a                	mv	s2,a0
    80003c56:	64e2                	ld	s1,24(sp)
    80003c58:	69a2                	ld	s3,8(sp)
    80003c5a:	bf65                	j	80003c12 <fileread+0x64>
    panic("fileread");
    80003c5c:	00005517          	auipc	a0,0x5
    80003c60:	91450513          	add	a0,a0,-1772 # 80008570 <etext+0x570>
    80003c64:	00002097          	auipc	ra,0x2
    80003c68:	12e080e7          	jalr	302(ra) # 80005d92 <panic>
    return -1;
    80003c6c:	597d                	li	s2,-1
    80003c6e:	b755                	j	80003c12 <fileread+0x64>
      return -1;
    80003c70:	597d                	li	s2,-1
    80003c72:	64e2                	ld	s1,24(sp)
    80003c74:	69a2                	ld	s3,8(sp)
    80003c76:	bf71                	j	80003c12 <fileread+0x64>
    80003c78:	597d                	li	s2,-1
    80003c7a:	64e2                	ld	s1,24(sp)
    80003c7c:	69a2                	ld	s3,8(sp)
    80003c7e:	bf51                	j	80003c12 <fileread+0x64>

0000000080003c80 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c80:	00954783          	lbu	a5,9(a0)
    80003c84:	12078963          	beqz	a5,80003db6 <filewrite+0x136>
{
    80003c88:	715d                	add	sp,sp,-80
    80003c8a:	e486                	sd	ra,72(sp)
    80003c8c:	e0a2                	sd	s0,64(sp)
    80003c8e:	f84a                	sd	s2,48(sp)
    80003c90:	f052                	sd	s4,32(sp)
    80003c92:	e85a                	sd	s6,16(sp)
    80003c94:	0880                	add	s0,sp,80
    80003c96:	892a                	mv	s2,a0
    80003c98:	8b2e                	mv	s6,a1
    80003c9a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c9c:	411c                	lw	a5,0(a0)
    80003c9e:	4705                	li	a4,1
    80003ca0:	02e78763          	beq	a5,a4,80003cce <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ca4:	470d                	li	a4,3
    80003ca6:	02e78a63          	beq	a5,a4,80003cda <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003caa:	4709                	li	a4,2
    80003cac:	0ee79863          	bne	a5,a4,80003d9c <filewrite+0x11c>
    80003cb0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cb2:	0cc05463          	blez	a2,80003d7a <filewrite+0xfa>
    80003cb6:	fc26                	sd	s1,56(sp)
    80003cb8:	ec56                	sd	s5,24(sp)
    80003cba:	e45e                	sd	s7,8(sp)
    80003cbc:	e062                	sd	s8,0(sp)
    int i = 0;
    80003cbe:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cc0:	6b85                	lui	s7,0x1
    80003cc2:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cc6:	6c05                	lui	s8,0x1
    80003cc8:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ccc:	a851                	j	80003d60 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003cce:	6908                	ld	a0,16(a0)
    80003cd0:	00000097          	auipc	ra,0x0
    80003cd4:	248080e7          	jalr	584(ra) # 80003f18 <pipewrite>
    80003cd8:	a85d                	j	80003d8e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cda:	02451783          	lh	a5,36(a0)
    80003cde:	03079693          	sll	a3,a5,0x30
    80003ce2:	92c1                	srl	a3,a3,0x30
    80003ce4:	4725                	li	a4,9
    80003ce6:	0cd76a63          	bltu	a4,a3,80003dba <filewrite+0x13a>
    80003cea:	0792                	sll	a5,a5,0x4
    80003cec:	00015717          	auipc	a4,0x15
    80003cf0:	cac70713          	add	a4,a4,-852 # 80018998 <devsw>
    80003cf4:	97ba                	add	a5,a5,a4
    80003cf6:	679c                	ld	a5,8(a5)
    80003cf8:	c3f9                	beqz	a5,80003dbe <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003cfa:	4505                	li	a0,1
    80003cfc:	9782                	jalr	a5
    80003cfe:	a841                	j	80003d8e <filewrite+0x10e>
      if(n1 > max)
    80003d00:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	88c080e7          	jalr	-1908(ra) # 80003590 <begin_op>
      ilock(f->ip);
    80003d0c:	01893503          	ld	a0,24(s2)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	eb2080e7          	jalr	-334(ra) # 80002bc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d18:	8756                	mv	a4,s5
    80003d1a:	02092683          	lw	a3,32(s2)
    80003d1e:	01698633          	add	a2,s3,s6
    80003d22:	4585                	li	a1,1
    80003d24:	01893503          	ld	a0,24(s2)
    80003d28:	fffff097          	auipc	ra,0xfffff
    80003d2c:	262080e7          	jalr	610(ra) # 80002f8a <writei>
    80003d30:	84aa                	mv	s1,a0
    80003d32:	00a05763          	blez	a0,80003d40 <filewrite+0xc0>
        f->off += r;
    80003d36:	02092783          	lw	a5,32(s2)
    80003d3a:	9fa9                	addw	a5,a5,a0
    80003d3c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d40:	01893503          	ld	a0,24(s2)
    80003d44:	fffff097          	auipc	ra,0xfffff
    80003d48:	f44080e7          	jalr	-188(ra) # 80002c88 <iunlock>
      end_op();
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	8be080e7          	jalr	-1858(ra) # 8000360a <end_op>

      if(r != n1){
    80003d54:	029a9563          	bne	s5,s1,80003d7e <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003d58:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d5c:	0149da63          	bge	s3,s4,80003d70 <filewrite+0xf0>
      int n1 = n - i;
    80003d60:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d64:	0004879b          	sext.w	a5,s1
    80003d68:	f8fbdce3          	bge	s7,a5,80003d00 <filewrite+0x80>
    80003d6c:	84e2                	mv	s1,s8
    80003d6e:	bf49                	j	80003d00 <filewrite+0x80>
    80003d70:	74e2                	ld	s1,56(sp)
    80003d72:	6ae2                	ld	s5,24(sp)
    80003d74:	6ba2                	ld	s7,8(sp)
    80003d76:	6c02                	ld	s8,0(sp)
    80003d78:	a039                	j	80003d86 <filewrite+0x106>
    int i = 0;
    80003d7a:	4981                	li	s3,0
    80003d7c:	a029                	j	80003d86 <filewrite+0x106>
    80003d7e:	74e2                	ld	s1,56(sp)
    80003d80:	6ae2                	ld	s5,24(sp)
    80003d82:	6ba2                	ld	s7,8(sp)
    80003d84:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003d86:	033a1e63          	bne	s4,s3,80003dc2 <filewrite+0x142>
    80003d8a:	8552                	mv	a0,s4
    80003d8c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d8e:	60a6                	ld	ra,72(sp)
    80003d90:	6406                	ld	s0,64(sp)
    80003d92:	7942                	ld	s2,48(sp)
    80003d94:	7a02                	ld	s4,32(sp)
    80003d96:	6b42                	ld	s6,16(sp)
    80003d98:	6161                	add	sp,sp,80
    80003d9a:	8082                	ret
    80003d9c:	fc26                	sd	s1,56(sp)
    80003d9e:	f44e                	sd	s3,40(sp)
    80003da0:	ec56                	sd	s5,24(sp)
    80003da2:	e45e                	sd	s7,8(sp)
    80003da4:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003da6:	00004517          	auipc	a0,0x4
    80003daa:	7da50513          	add	a0,a0,2010 # 80008580 <etext+0x580>
    80003dae:	00002097          	auipc	ra,0x2
    80003db2:	fe4080e7          	jalr	-28(ra) # 80005d92 <panic>
    return -1;
    80003db6:	557d                	li	a0,-1
}
    80003db8:	8082                	ret
      return -1;
    80003dba:	557d                	li	a0,-1
    80003dbc:	bfc9                	j	80003d8e <filewrite+0x10e>
    80003dbe:	557d                	li	a0,-1
    80003dc0:	b7f9                	j	80003d8e <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003dc2:	557d                	li	a0,-1
    80003dc4:	79a2                	ld	s3,40(sp)
    80003dc6:	b7e1                	j	80003d8e <filewrite+0x10e>

0000000080003dc8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dc8:	7179                	add	sp,sp,-48
    80003dca:	f406                	sd	ra,40(sp)
    80003dcc:	f022                	sd	s0,32(sp)
    80003dce:	ec26                	sd	s1,24(sp)
    80003dd0:	e052                	sd	s4,0(sp)
    80003dd2:	1800                	add	s0,sp,48
    80003dd4:	84aa                	mv	s1,a0
    80003dd6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dd8:	0005b023          	sd	zero,0(a1)
    80003ddc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003de0:	00000097          	auipc	ra,0x0
    80003de4:	bbe080e7          	jalr	-1090(ra) # 8000399e <filealloc>
    80003de8:	e088                	sd	a0,0(s1)
    80003dea:	cd49                	beqz	a0,80003e84 <pipealloc+0xbc>
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	bb2080e7          	jalr	-1102(ra) # 8000399e <filealloc>
    80003df4:	00aa3023          	sd	a0,0(s4)
    80003df8:	c141                	beqz	a0,80003e78 <pipealloc+0xb0>
    80003dfa:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dfc:	ffffc097          	auipc	ra,0xffffc
    80003e00:	31e080e7          	jalr	798(ra) # 8000011a <kalloc>
    80003e04:	892a                	mv	s2,a0
    80003e06:	c13d                	beqz	a0,80003e6c <pipealloc+0xa4>
    80003e08:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e0a:	4985                	li	s3,1
    80003e0c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e10:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e14:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e18:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e1c:	00004597          	auipc	a1,0x4
    80003e20:	77458593          	add	a1,a1,1908 # 80008590 <etext+0x590>
    80003e24:	00002097          	auipc	ra,0x2
    80003e28:	458080e7          	jalr	1112(ra) # 8000627c <initlock>
  (*f0)->type = FD_PIPE;
    80003e2c:	609c                	ld	a5,0(s1)
    80003e2e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e32:	609c                	ld	a5,0(s1)
    80003e34:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e38:	609c                	ld	a5,0(s1)
    80003e3a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e3e:	609c                	ld	a5,0(s1)
    80003e40:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e44:	000a3783          	ld	a5,0(s4)
    80003e48:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e4c:	000a3783          	ld	a5,0(s4)
    80003e50:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e54:	000a3783          	ld	a5,0(s4)
    80003e58:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e5c:	000a3783          	ld	a5,0(s4)
    80003e60:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e64:	4501                	li	a0,0
    80003e66:	6942                	ld	s2,16(sp)
    80003e68:	69a2                	ld	s3,8(sp)
    80003e6a:	a03d                	j	80003e98 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e6c:	6088                	ld	a0,0(s1)
    80003e6e:	c119                	beqz	a0,80003e74 <pipealloc+0xac>
    80003e70:	6942                	ld	s2,16(sp)
    80003e72:	a029                	j	80003e7c <pipealloc+0xb4>
    80003e74:	6942                	ld	s2,16(sp)
    80003e76:	a039                	j	80003e84 <pipealloc+0xbc>
    80003e78:	6088                	ld	a0,0(s1)
    80003e7a:	c50d                	beqz	a0,80003ea4 <pipealloc+0xdc>
    fileclose(*f0);
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	bde080e7          	jalr	-1058(ra) # 80003a5a <fileclose>
  if(*f1)
    80003e84:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e88:	557d                	li	a0,-1
  if(*f1)
    80003e8a:	c799                	beqz	a5,80003e98 <pipealloc+0xd0>
    fileclose(*f1);
    80003e8c:	853e                	mv	a0,a5
    80003e8e:	00000097          	auipc	ra,0x0
    80003e92:	bcc080e7          	jalr	-1076(ra) # 80003a5a <fileclose>
  return -1;
    80003e96:	557d                	li	a0,-1
}
    80003e98:	70a2                	ld	ra,40(sp)
    80003e9a:	7402                	ld	s0,32(sp)
    80003e9c:	64e2                	ld	s1,24(sp)
    80003e9e:	6a02                	ld	s4,0(sp)
    80003ea0:	6145                	add	sp,sp,48
    80003ea2:	8082                	ret
  return -1;
    80003ea4:	557d                	li	a0,-1
    80003ea6:	bfcd                	j	80003e98 <pipealloc+0xd0>

0000000080003ea8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ea8:	1101                	add	sp,sp,-32
    80003eaa:	ec06                	sd	ra,24(sp)
    80003eac:	e822                	sd	s0,16(sp)
    80003eae:	e426                	sd	s1,8(sp)
    80003eb0:	e04a                	sd	s2,0(sp)
    80003eb2:	1000                	add	s0,sp,32
    80003eb4:	84aa                	mv	s1,a0
    80003eb6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eb8:	00002097          	auipc	ra,0x2
    80003ebc:	454080e7          	jalr	1108(ra) # 8000630c <acquire>
  if(writable){
    80003ec0:	02090d63          	beqz	s2,80003efa <pipeclose+0x52>
    pi->writeopen = 0;
    80003ec4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ec8:	21848513          	add	a0,s1,536
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	74c080e7          	jalr	1868(ra) # 80001618 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ed4:	2204b783          	ld	a5,544(s1)
    80003ed8:	eb95                	bnez	a5,80003f0c <pipeclose+0x64>
    release(&pi->lock);
    80003eda:	8526                	mv	a0,s1
    80003edc:	00002097          	auipc	ra,0x2
    80003ee0:	4e4080e7          	jalr	1252(ra) # 800063c0 <release>
    kfree((char*)pi);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	ffffc097          	auipc	ra,0xffffc
    80003eea:	136080e7          	jalr	310(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eee:	60e2                	ld	ra,24(sp)
    80003ef0:	6442                	ld	s0,16(sp)
    80003ef2:	64a2                	ld	s1,8(sp)
    80003ef4:	6902                	ld	s2,0(sp)
    80003ef6:	6105                	add	sp,sp,32
    80003ef8:	8082                	ret
    pi->readopen = 0;
    80003efa:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003efe:	21c48513          	add	a0,s1,540
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	716080e7          	jalr	1814(ra) # 80001618 <wakeup>
    80003f0a:	b7e9                	j	80003ed4 <pipeclose+0x2c>
    release(&pi->lock);
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	4b2080e7          	jalr	1202(ra) # 800063c0 <release>
}
    80003f16:	bfe1                	j	80003eee <pipeclose+0x46>

0000000080003f18 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f18:	711d                	add	sp,sp,-96
    80003f1a:	ec86                	sd	ra,88(sp)
    80003f1c:	e8a2                	sd	s0,80(sp)
    80003f1e:	e4a6                	sd	s1,72(sp)
    80003f20:	e0ca                	sd	s2,64(sp)
    80003f22:	fc4e                	sd	s3,56(sp)
    80003f24:	f852                	sd	s4,48(sp)
    80003f26:	f456                	sd	s5,40(sp)
    80003f28:	1080                	add	s0,sp,96
    80003f2a:	84aa                	mv	s1,a0
    80003f2c:	8aae                	mv	s5,a1
    80003f2e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	fd6080e7          	jalr	-42(ra) # 80000f06 <myproc>
    80003f38:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	3d0080e7          	jalr	976(ra) # 8000630c <acquire>
  while(i < n){
    80003f44:	0d405863          	blez	s4,80004014 <pipewrite+0xfc>
    80003f48:	f05a                	sd	s6,32(sp)
    80003f4a:	ec5e                	sd	s7,24(sp)
    80003f4c:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f4e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f50:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f52:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f56:	21c48b93          	add	s7,s1,540
    80003f5a:	a089                	j	80003f9c <pipewrite+0x84>
      release(&pi->lock);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	462080e7          	jalr	1122(ra) # 800063c0 <release>
      return -1;
    80003f66:	597d                	li	s2,-1
    80003f68:	7b02                	ld	s6,32(sp)
    80003f6a:	6be2                	ld	s7,24(sp)
    80003f6c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f6e:	854a                	mv	a0,s2
    80003f70:	60e6                	ld	ra,88(sp)
    80003f72:	6446                	ld	s0,80(sp)
    80003f74:	64a6                	ld	s1,72(sp)
    80003f76:	6906                	ld	s2,64(sp)
    80003f78:	79e2                	ld	s3,56(sp)
    80003f7a:	7a42                	ld	s4,48(sp)
    80003f7c:	7aa2                	ld	s5,40(sp)
    80003f7e:	6125                	add	sp,sp,96
    80003f80:	8082                	ret
      wakeup(&pi->nread);
    80003f82:	8562                	mv	a0,s8
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	694080e7          	jalr	1684(ra) # 80001618 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f8c:	85a6                	mv	a1,s1
    80003f8e:	855e                	mv	a0,s7
    80003f90:	ffffd097          	auipc	ra,0xffffd
    80003f94:	624080e7          	jalr	1572(ra) # 800015b4 <sleep>
  while(i < n){
    80003f98:	05495f63          	bge	s2,s4,80003ff6 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80003f9c:	2204a783          	lw	a5,544(s1)
    80003fa0:	dfd5                	beqz	a5,80003f5c <pipewrite+0x44>
    80003fa2:	854e                	mv	a0,s3
    80003fa4:	ffffe097          	auipc	ra,0xffffe
    80003fa8:	8b8080e7          	jalr	-1864(ra) # 8000185c <killed>
    80003fac:	f945                	bnez	a0,80003f5c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fae:	2184a783          	lw	a5,536(s1)
    80003fb2:	21c4a703          	lw	a4,540(s1)
    80003fb6:	2007879b          	addw	a5,a5,512
    80003fba:	fcf704e3          	beq	a4,a5,80003f82 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fbe:	4685                	li	a3,1
    80003fc0:	01590633          	add	a2,s2,s5
    80003fc4:	faf40593          	add	a1,s0,-81
    80003fc8:	0509b503          	ld	a0,80(s3)
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	c5e080e7          	jalr	-930(ra) # 80000c2a <copyin>
    80003fd4:	05650263          	beq	a0,s6,80004018 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fd8:	21c4a783          	lw	a5,540(s1)
    80003fdc:	0017871b          	addw	a4,a5,1
    80003fe0:	20e4ae23          	sw	a4,540(s1)
    80003fe4:	1ff7f793          	and	a5,a5,511
    80003fe8:	97a6                	add	a5,a5,s1
    80003fea:	faf44703          	lbu	a4,-81(s0)
    80003fee:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ff2:	2905                	addw	s2,s2,1
    80003ff4:	b755                	j	80003f98 <pipewrite+0x80>
    80003ff6:	7b02                	ld	s6,32(sp)
    80003ff8:	6be2                	ld	s7,24(sp)
    80003ffa:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003ffc:	21848513          	add	a0,s1,536
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	618080e7          	jalr	1560(ra) # 80001618 <wakeup>
  release(&pi->lock);
    80004008:	8526                	mv	a0,s1
    8000400a:	00002097          	auipc	ra,0x2
    8000400e:	3b6080e7          	jalr	950(ra) # 800063c0 <release>
  return i;
    80004012:	bfb1                	j	80003f6e <pipewrite+0x56>
  int i = 0;
    80004014:	4901                	li	s2,0
    80004016:	b7dd                	j	80003ffc <pipewrite+0xe4>
    80004018:	7b02                	ld	s6,32(sp)
    8000401a:	6be2                	ld	s7,24(sp)
    8000401c:	6c42                	ld	s8,16(sp)
    8000401e:	bff9                	j	80003ffc <pipewrite+0xe4>

0000000080004020 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004020:	715d                	add	sp,sp,-80
    80004022:	e486                	sd	ra,72(sp)
    80004024:	e0a2                	sd	s0,64(sp)
    80004026:	fc26                	sd	s1,56(sp)
    80004028:	f84a                	sd	s2,48(sp)
    8000402a:	f44e                	sd	s3,40(sp)
    8000402c:	f052                	sd	s4,32(sp)
    8000402e:	ec56                	sd	s5,24(sp)
    80004030:	0880                	add	s0,sp,80
    80004032:	84aa                	mv	s1,a0
    80004034:	892e                	mv	s2,a1
    80004036:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	ece080e7          	jalr	-306(ra) # 80000f06 <myproc>
    80004040:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004042:	8526                	mv	a0,s1
    80004044:	00002097          	auipc	ra,0x2
    80004048:	2c8080e7          	jalr	712(ra) # 8000630c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000404c:	2184a703          	lw	a4,536(s1)
    80004050:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004054:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004058:	02f71963          	bne	a4,a5,8000408a <piperead+0x6a>
    8000405c:	2244a783          	lw	a5,548(s1)
    80004060:	cf95                	beqz	a5,8000409c <piperead+0x7c>
    if(killed(pr)){
    80004062:	8552                	mv	a0,s4
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	7f8080e7          	jalr	2040(ra) # 8000185c <killed>
    8000406c:	e10d                	bnez	a0,8000408e <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000406e:	85a6                	mv	a1,s1
    80004070:	854e                	mv	a0,s3
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	542080e7          	jalr	1346(ra) # 800015b4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000407a:	2184a703          	lw	a4,536(s1)
    8000407e:	21c4a783          	lw	a5,540(s1)
    80004082:	fcf70de3          	beq	a4,a5,8000405c <piperead+0x3c>
    80004086:	e85a                	sd	s6,16(sp)
    80004088:	a819                	j	8000409e <piperead+0x7e>
    8000408a:	e85a                	sd	s6,16(sp)
    8000408c:	a809                	j	8000409e <piperead+0x7e>
      release(&pi->lock);
    8000408e:	8526                	mv	a0,s1
    80004090:	00002097          	auipc	ra,0x2
    80004094:	330080e7          	jalr	816(ra) # 800063c0 <release>
      return -1;
    80004098:	59fd                	li	s3,-1
    8000409a:	a0a5                	j	80004102 <piperead+0xe2>
    8000409c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040a0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a2:	05505463          	blez	s5,800040ea <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800040a6:	2184a783          	lw	a5,536(s1)
    800040aa:	21c4a703          	lw	a4,540(s1)
    800040ae:	02f70e63          	beq	a4,a5,800040ea <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040b2:	0017871b          	addw	a4,a5,1
    800040b6:	20e4ac23          	sw	a4,536(s1)
    800040ba:	1ff7f793          	and	a5,a5,511
    800040be:	97a6                	add	a5,a5,s1
    800040c0:	0187c783          	lbu	a5,24(a5)
    800040c4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040c8:	4685                	li	a3,1
    800040ca:	fbf40613          	add	a2,s0,-65
    800040ce:	85ca                	mv	a1,s2
    800040d0:	050a3503          	ld	a0,80(s4)
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	a78080e7          	jalr	-1416(ra) # 80000b4c <copyout>
    800040dc:	01650763          	beq	a0,s6,800040ea <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e0:	2985                	addw	s3,s3,1
    800040e2:	0905                	add	s2,s2,1
    800040e4:	fd3a91e3          	bne	s5,s3,800040a6 <piperead+0x86>
    800040e8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ea:	21c48513          	add	a0,s1,540
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	52a080e7          	jalr	1322(ra) # 80001618 <wakeup>
  release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	2c8080e7          	jalr	712(ra) # 800063c0 <release>
    80004100:	6b42                	ld	s6,16(sp)
  return i;
}
    80004102:	854e                	mv	a0,s3
    80004104:	60a6                	ld	ra,72(sp)
    80004106:	6406                	ld	s0,64(sp)
    80004108:	74e2                	ld	s1,56(sp)
    8000410a:	7942                	ld	s2,48(sp)
    8000410c:	79a2                	ld	s3,40(sp)
    8000410e:	7a02                	ld	s4,32(sp)
    80004110:	6ae2                	ld	s5,24(sp)
    80004112:	6161                	add	sp,sp,80
    80004114:	8082                	ret

0000000080004116 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004116:	1141                	add	sp,sp,-16
    80004118:	e422                	sd	s0,8(sp)
    8000411a:	0800                	add	s0,sp,16
    8000411c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000411e:	8905                	and	a0,a0,1
    80004120:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004122:	8b89                	and	a5,a5,2
    80004124:	c399                	beqz	a5,8000412a <flags2perm+0x14>
      perm |= PTE_W;
    80004126:	00456513          	or	a0,a0,4
    return perm;
}
    8000412a:	6422                	ld	s0,8(sp)
    8000412c:	0141                	add	sp,sp,16
    8000412e:	8082                	ret

0000000080004130 <exec>:

int
exec(char *path, char **argv)
{
    80004130:	df010113          	add	sp,sp,-528
    80004134:	20113423          	sd	ra,520(sp)
    80004138:	20813023          	sd	s0,512(sp)
    8000413c:	ffa6                	sd	s1,504(sp)
    8000413e:	fbca                	sd	s2,496(sp)
    80004140:	0c00                	add	s0,sp,528
    80004142:	892a                	mv	s2,a0
    80004144:	dea43c23          	sd	a0,-520(s0)
    80004148:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	dba080e7          	jalr	-582(ra) # 80000f06 <myproc>
    80004154:	84aa                	mv	s1,a0

  begin_op();
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	43a080e7          	jalr	1082(ra) # 80003590 <begin_op>

  if((ip = namei(path)) == 0){
    8000415e:	854a                	mv	a0,s2
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	230080e7          	jalr	560(ra) # 80003390 <namei>
    80004168:	c135                	beqz	a0,800041cc <exec+0x9c>
    8000416a:	f3d2                	sd	s4,480(sp)
    8000416c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000416e:	fffff097          	auipc	ra,0xfffff
    80004172:	a54080e7          	jalr	-1452(ra) # 80002bc2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004176:	04000713          	li	a4,64
    8000417a:	4681                	li	a3,0
    8000417c:	e5040613          	add	a2,s0,-432
    80004180:	4581                	li	a1,0
    80004182:	8552                	mv	a0,s4
    80004184:	fffff097          	auipc	ra,0xfffff
    80004188:	cf6080e7          	jalr	-778(ra) # 80002e7a <readi>
    8000418c:	04000793          	li	a5,64
    80004190:	00f51a63          	bne	a0,a5,800041a4 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004194:	e5042703          	lw	a4,-432(s0)
    80004198:	464c47b7          	lui	a5,0x464c4
    8000419c:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041a0:	02f70c63          	beq	a4,a5,800041d8 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041a4:	8552                	mv	a0,s4
    800041a6:	fffff097          	auipc	ra,0xfffff
    800041aa:	c82080e7          	jalr	-894(ra) # 80002e28 <iunlockput>
    end_op();
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	45c080e7          	jalr	1116(ra) # 8000360a <end_op>
  }
  return -1;
    800041b6:	557d                	li	a0,-1
    800041b8:	7a1e                	ld	s4,480(sp)
}
    800041ba:	20813083          	ld	ra,520(sp)
    800041be:	20013403          	ld	s0,512(sp)
    800041c2:	74fe                	ld	s1,504(sp)
    800041c4:	795e                	ld	s2,496(sp)
    800041c6:	21010113          	add	sp,sp,528
    800041ca:	8082                	ret
    end_op();
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	43e080e7          	jalr	1086(ra) # 8000360a <end_op>
    return -1;
    800041d4:	557d                	li	a0,-1
    800041d6:	b7d5                	j	800041ba <exec+0x8a>
    800041d8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800041da:	8526                	mv	a0,s1
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	df2080e7          	jalr	-526(ra) # 80000fce <proc_pagetable>
    800041e4:	8b2a                	mv	s6,a0
    800041e6:	30050f63          	beqz	a0,80004504 <exec+0x3d4>
    800041ea:	f7ce                	sd	s3,488(sp)
    800041ec:	efd6                	sd	s5,472(sp)
    800041ee:	e7de                	sd	s7,456(sp)
    800041f0:	e3e2                	sd	s8,448(sp)
    800041f2:	ff66                	sd	s9,440(sp)
    800041f4:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f6:	e7042d03          	lw	s10,-400(s0)
    800041fa:	e8845783          	lhu	a5,-376(s0)
    800041fe:	14078d63          	beqz	a5,80004358 <exec+0x228>
    80004202:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004204:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004206:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004208:	6c85                	lui	s9,0x1
    8000420a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000420e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004212:	6a85                	lui	s5,0x1
    80004214:	a0b5                	j	80004280 <exec+0x150>
      panic("loadseg: address should exist");
    80004216:	00004517          	auipc	a0,0x4
    8000421a:	38250513          	add	a0,a0,898 # 80008598 <etext+0x598>
    8000421e:	00002097          	auipc	ra,0x2
    80004222:	b74080e7          	jalr	-1164(ra) # 80005d92 <panic>
    if(sz - i < PGSIZE)
    80004226:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004228:	8726                	mv	a4,s1
    8000422a:	012c06bb          	addw	a3,s8,s2
    8000422e:	4581                	li	a1,0
    80004230:	8552                	mv	a0,s4
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	c48080e7          	jalr	-952(ra) # 80002e7a <readi>
    8000423a:	2501                	sext.w	a0,a0
    8000423c:	28a49863          	bne	s1,a0,800044cc <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80004240:	012a893b          	addw	s2,s5,s2
    80004244:	03397563          	bgeu	s2,s3,8000426e <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004248:	02091593          	sll	a1,s2,0x20
    8000424c:	9181                	srl	a1,a1,0x20
    8000424e:	95de                	add	a1,a1,s7
    80004250:	855a                	mv	a0,s6
    80004252:	ffffc097          	auipc	ra,0xffffc
    80004256:	2aa080e7          	jalr	682(ra) # 800004fc <walkaddr>
    8000425a:	862a                	mv	a2,a0
    if(pa == 0)
    8000425c:	dd4d                	beqz	a0,80004216 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000425e:	412984bb          	subw	s1,s3,s2
    80004262:	0004879b          	sext.w	a5,s1
    80004266:	fcfcf0e3          	bgeu	s9,a5,80004226 <exec+0xf6>
    8000426a:	84d6                	mv	s1,s5
    8000426c:	bf6d                	j	80004226 <exec+0xf6>
    sz = sz1;
    8000426e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004272:	2d85                	addw	s11,s11,1
    80004274:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004278:	e8845783          	lhu	a5,-376(s0)
    8000427c:	08fdd663          	bge	s11,a5,80004308 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004280:	2d01                	sext.w	s10,s10
    80004282:	03800713          	li	a4,56
    80004286:	86ea                	mv	a3,s10
    80004288:	e1840613          	add	a2,s0,-488
    8000428c:	4581                	li	a1,0
    8000428e:	8552                	mv	a0,s4
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	bea080e7          	jalr	-1046(ra) # 80002e7a <readi>
    80004298:	03800793          	li	a5,56
    8000429c:	20f51063          	bne	a0,a5,8000449c <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800042a0:	e1842783          	lw	a5,-488(s0)
    800042a4:	4705                	li	a4,1
    800042a6:	fce796e3          	bne	a5,a4,80004272 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042aa:	e4043483          	ld	s1,-448(s0)
    800042ae:	e3843783          	ld	a5,-456(s0)
    800042b2:	1ef4e963          	bltu	s1,a5,800044a4 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042b6:	e2843783          	ld	a5,-472(s0)
    800042ba:	94be                	add	s1,s1,a5
    800042bc:	1ef4e863          	bltu	s1,a5,800044ac <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800042c0:	df043703          	ld	a4,-528(s0)
    800042c4:	8ff9                	and	a5,a5,a4
    800042c6:	1e079763          	bnez	a5,800044b4 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042ca:	e1c42503          	lw	a0,-484(s0)
    800042ce:	00000097          	auipc	ra,0x0
    800042d2:	e48080e7          	jalr	-440(ra) # 80004116 <flags2perm>
    800042d6:	86aa                	mv	a3,a0
    800042d8:	8626                	mv	a2,s1
    800042da:	85ca                	mv	a1,s2
    800042dc:	855a                	mv	a0,s6
    800042de:	ffffc097          	auipc	ra,0xffffc
    800042e2:	606080e7          	jalr	1542(ra) # 800008e4 <uvmalloc>
    800042e6:	e0a43423          	sd	a0,-504(s0)
    800042ea:	1c050963          	beqz	a0,800044bc <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042ee:	e2843b83          	ld	s7,-472(s0)
    800042f2:	e2042c03          	lw	s8,-480(s0)
    800042f6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042fa:	00098463          	beqz	s3,80004302 <exec+0x1d2>
    800042fe:	4901                	li	s2,0
    80004300:	b7a1                	j	80004248 <exec+0x118>
    sz = sz1;
    80004302:	e0843903          	ld	s2,-504(s0)
    80004306:	b7b5                	j	80004272 <exec+0x142>
    80004308:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000430a:	8552                	mv	a0,s4
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	b1c080e7          	jalr	-1252(ra) # 80002e28 <iunlockput>
  end_op();
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	2f6080e7          	jalr	758(ra) # 8000360a <end_op>
  p = myproc();
    8000431c:	ffffd097          	auipc	ra,0xffffd
    80004320:	bea080e7          	jalr	-1046(ra) # 80000f06 <myproc>
    80004324:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004326:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000432a:	6985                	lui	s3,0x1
    8000432c:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000432e:	99ca                	add	s3,s3,s2
    80004330:	77fd                	lui	a5,0xfffff
    80004332:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004336:	4691                	li	a3,4
    80004338:	6609                	lui	a2,0x2
    8000433a:	964e                	add	a2,a2,s3
    8000433c:	85ce                	mv	a1,s3
    8000433e:	855a                	mv	a0,s6
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	5a4080e7          	jalr	1444(ra) # 800008e4 <uvmalloc>
    80004348:	892a                	mv	s2,a0
    8000434a:	e0a43423          	sd	a0,-504(s0)
    8000434e:	e519                	bnez	a0,8000435c <exec+0x22c>
  if(pagetable)
    80004350:	e1343423          	sd	s3,-504(s0)
    80004354:	4a01                	li	s4,0
    80004356:	aaa5                	j	800044ce <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004358:	4901                	li	s2,0
    8000435a:	bf45                	j	8000430a <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000435c:	75f9                	lui	a1,0xffffe
    8000435e:	95aa                	add	a1,a1,a0
    80004360:	855a                	mv	a0,s6
    80004362:	ffffc097          	auipc	ra,0xffffc
    80004366:	7b8080e7          	jalr	1976(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    8000436a:	7bfd                	lui	s7,0xfffff
    8000436c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000436e:	e0043783          	ld	a5,-512(s0)
    80004372:	6388                	ld	a0,0(a5)
    80004374:	c52d                	beqz	a0,800043de <exec+0x2ae>
    80004376:	e9040993          	add	s3,s0,-368
    8000437a:	f9040c13          	add	s8,s0,-112
    8000437e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	f6e080e7          	jalr	-146(ra) # 800002ee <strlen>
    80004388:	0015079b          	addw	a5,a0,1
    8000438c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004390:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004394:	13796863          	bltu	s2,s7,800044c4 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004398:	e0043d03          	ld	s10,-512(s0)
    8000439c:	000d3a03          	ld	s4,0(s10)
    800043a0:	8552                	mv	a0,s4
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	f4c080e7          	jalr	-180(ra) # 800002ee <strlen>
    800043aa:	0015069b          	addw	a3,a0,1
    800043ae:	8652                	mv	a2,s4
    800043b0:	85ca                	mv	a1,s2
    800043b2:	855a                	mv	a0,s6
    800043b4:	ffffc097          	auipc	ra,0xffffc
    800043b8:	798080e7          	jalr	1944(ra) # 80000b4c <copyout>
    800043bc:	10054663          	bltz	a0,800044c8 <exec+0x398>
    ustack[argc] = sp;
    800043c0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043c4:	0485                	add	s1,s1,1
    800043c6:	008d0793          	add	a5,s10,8
    800043ca:	e0f43023          	sd	a5,-512(s0)
    800043ce:	008d3503          	ld	a0,8(s10)
    800043d2:	c909                	beqz	a0,800043e4 <exec+0x2b4>
    if(argc >= MAXARG)
    800043d4:	09a1                	add	s3,s3,8
    800043d6:	fb8995e3          	bne	s3,s8,80004380 <exec+0x250>
  ip = 0;
    800043da:	4a01                	li	s4,0
    800043dc:	a8cd                	j	800044ce <exec+0x39e>
  sp = sz;
    800043de:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043e2:	4481                	li	s1,0
  ustack[argc] = 0;
    800043e4:	00349793          	sll	a5,s1,0x3
    800043e8:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd220>
    800043ec:	97a2                	add	a5,a5,s0
    800043ee:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043f2:	00148693          	add	a3,s1,1
    800043f6:	068e                	sll	a3,a3,0x3
    800043f8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043fc:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004400:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004404:	f57966e3          	bltu	s2,s7,80004350 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004408:	e9040613          	add	a2,s0,-368
    8000440c:	85ca                	mv	a1,s2
    8000440e:	855a                	mv	a0,s6
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	73c080e7          	jalr	1852(ra) # 80000b4c <copyout>
    80004418:	0e054863          	bltz	a0,80004508 <exec+0x3d8>
  p->trapframe->a1 = sp;
    8000441c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004420:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004424:	df843783          	ld	a5,-520(s0)
    80004428:	0007c703          	lbu	a4,0(a5)
    8000442c:	cf11                	beqz	a4,80004448 <exec+0x318>
    8000442e:	0785                	add	a5,a5,1
    if(*s == '/')
    80004430:	02f00693          	li	a3,47
    80004434:	a039                	j	80004442 <exec+0x312>
      last = s+1;
    80004436:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000443a:	0785                	add	a5,a5,1
    8000443c:	fff7c703          	lbu	a4,-1(a5)
    80004440:	c701                	beqz	a4,80004448 <exec+0x318>
    if(*s == '/')
    80004442:	fed71ce3          	bne	a4,a3,8000443a <exec+0x30a>
    80004446:	bfc5                	j	80004436 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004448:	4641                	li	a2,16
    8000444a:	df843583          	ld	a1,-520(s0)
    8000444e:	158a8513          	add	a0,s5,344
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	e6a080e7          	jalr	-406(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000445a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000445e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004462:	e0843783          	ld	a5,-504(s0)
    80004466:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000446a:	058ab783          	ld	a5,88(s5)
    8000446e:	e6843703          	ld	a4,-408(s0)
    80004472:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004474:	058ab783          	ld	a5,88(s5)
    80004478:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000447c:	85e6                	mv	a1,s9
    8000447e:	ffffd097          	auipc	ra,0xffffd
    80004482:	bec080e7          	jalr	-1044(ra) # 8000106a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004486:	0004851b          	sext.w	a0,s1
    8000448a:	79be                	ld	s3,488(sp)
    8000448c:	7a1e                	ld	s4,480(sp)
    8000448e:	6afe                	ld	s5,472(sp)
    80004490:	6b5e                	ld	s6,464(sp)
    80004492:	6bbe                	ld	s7,456(sp)
    80004494:	6c1e                	ld	s8,448(sp)
    80004496:	7cfa                	ld	s9,440(sp)
    80004498:	7d5a                	ld	s10,432(sp)
    8000449a:	b305                	j	800041ba <exec+0x8a>
    8000449c:	e1243423          	sd	s2,-504(s0)
    800044a0:	7dba                	ld	s11,424(sp)
    800044a2:	a035                	j	800044ce <exec+0x39e>
    800044a4:	e1243423          	sd	s2,-504(s0)
    800044a8:	7dba                	ld	s11,424(sp)
    800044aa:	a015                	j	800044ce <exec+0x39e>
    800044ac:	e1243423          	sd	s2,-504(s0)
    800044b0:	7dba                	ld	s11,424(sp)
    800044b2:	a831                	j	800044ce <exec+0x39e>
    800044b4:	e1243423          	sd	s2,-504(s0)
    800044b8:	7dba                	ld	s11,424(sp)
    800044ba:	a811                	j	800044ce <exec+0x39e>
    800044bc:	e1243423          	sd	s2,-504(s0)
    800044c0:	7dba                	ld	s11,424(sp)
    800044c2:	a031                	j	800044ce <exec+0x39e>
  ip = 0;
    800044c4:	4a01                	li	s4,0
    800044c6:	a021                	j	800044ce <exec+0x39e>
    800044c8:	4a01                	li	s4,0
  if(pagetable)
    800044ca:	a011                	j	800044ce <exec+0x39e>
    800044cc:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044ce:	e0843583          	ld	a1,-504(s0)
    800044d2:	855a                	mv	a0,s6
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	b96080e7          	jalr	-1130(ra) # 8000106a <proc_freepagetable>
  return -1;
    800044dc:	557d                	li	a0,-1
  if(ip){
    800044de:	000a1b63          	bnez	s4,800044f4 <exec+0x3c4>
    800044e2:	79be                	ld	s3,488(sp)
    800044e4:	7a1e                	ld	s4,480(sp)
    800044e6:	6afe                	ld	s5,472(sp)
    800044e8:	6b5e                	ld	s6,464(sp)
    800044ea:	6bbe                	ld	s7,456(sp)
    800044ec:	6c1e                	ld	s8,448(sp)
    800044ee:	7cfa                	ld	s9,440(sp)
    800044f0:	7d5a                	ld	s10,432(sp)
    800044f2:	b1e1                	j	800041ba <exec+0x8a>
    800044f4:	79be                	ld	s3,488(sp)
    800044f6:	6afe                	ld	s5,472(sp)
    800044f8:	6b5e                	ld	s6,464(sp)
    800044fa:	6bbe                	ld	s7,456(sp)
    800044fc:	6c1e                	ld	s8,448(sp)
    800044fe:	7cfa                	ld	s9,440(sp)
    80004500:	7d5a                	ld	s10,432(sp)
    80004502:	b14d                	j	800041a4 <exec+0x74>
    80004504:	6b5e                	ld	s6,464(sp)
    80004506:	b979                	j	800041a4 <exec+0x74>
  sz = sz1;
    80004508:	e0843983          	ld	s3,-504(s0)
    8000450c:	b591                	j	80004350 <exec+0x220>

000000008000450e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000450e:	7179                	add	sp,sp,-48
    80004510:	f406                	sd	ra,40(sp)
    80004512:	f022                	sd	s0,32(sp)
    80004514:	ec26                	sd	s1,24(sp)
    80004516:	e84a                	sd	s2,16(sp)
    80004518:	1800                	add	s0,sp,48
    8000451a:	892e                	mv	s2,a1
    8000451c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000451e:	fdc40593          	add	a1,s0,-36
    80004522:	ffffe097          	auipc	ra,0xffffe
    80004526:	b08080e7          	jalr	-1272(ra) # 8000202a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000452a:	fdc42703          	lw	a4,-36(s0)
    8000452e:	47bd                	li	a5,15
    80004530:	02e7eb63          	bltu	a5,a4,80004566 <argfd+0x58>
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	9d2080e7          	jalr	-1582(ra) # 80000f06 <myproc>
    8000453c:	fdc42703          	lw	a4,-36(s0)
    80004540:	01a70793          	add	a5,a4,26
    80004544:	078e                	sll	a5,a5,0x3
    80004546:	953e                	add	a0,a0,a5
    80004548:	611c                	ld	a5,0(a0)
    8000454a:	c385                	beqz	a5,8000456a <argfd+0x5c>
    return -1;
  if(pfd)
    8000454c:	00090463          	beqz	s2,80004554 <argfd+0x46>
    *pfd = fd;
    80004550:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004554:	4501                	li	a0,0
  if(pf)
    80004556:	c091                	beqz	s1,8000455a <argfd+0x4c>
    *pf = f;
    80004558:	e09c                	sd	a5,0(s1)
}
    8000455a:	70a2                	ld	ra,40(sp)
    8000455c:	7402                	ld	s0,32(sp)
    8000455e:	64e2                	ld	s1,24(sp)
    80004560:	6942                	ld	s2,16(sp)
    80004562:	6145                	add	sp,sp,48
    80004564:	8082                	ret
    return -1;
    80004566:	557d                	li	a0,-1
    80004568:	bfcd                	j	8000455a <argfd+0x4c>
    8000456a:	557d                	li	a0,-1
    8000456c:	b7fd                	j	8000455a <argfd+0x4c>

000000008000456e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000456e:	1101                	add	sp,sp,-32
    80004570:	ec06                	sd	ra,24(sp)
    80004572:	e822                	sd	s0,16(sp)
    80004574:	e426                	sd	s1,8(sp)
    80004576:	1000                	add	s0,sp,32
    80004578:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000457a:	ffffd097          	auipc	ra,0xffffd
    8000457e:	98c080e7          	jalr	-1652(ra) # 80000f06 <myproc>
    80004582:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004584:	0d050793          	add	a5,a0,208
    80004588:	4501                	li	a0,0
    8000458a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000458c:	6398                	ld	a4,0(a5)
    8000458e:	cb19                	beqz	a4,800045a4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004590:	2505                	addw	a0,a0,1
    80004592:	07a1                	add	a5,a5,8
    80004594:	fed51ce3          	bne	a0,a3,8000458c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004598:	557d                	li	a0,-1
}
    8000459a:	60e2                	ld	ra,24(sp)
    8000459c:	6442                	ld	s0,16(sp)
    8000459e:	64a2                	ld	s1,8(sp)
    800045a0:	6105                	add	sp,sp,32
    800045a2:	8082                	ret
      p->ofile[fd] = f;
    800045a4:	01a50793          	add	a5,a0,26
    800045a8:	078e                	sll	a5,a5,0x3
    800045aa:	963e                	add	a2,a2,a5
    800045ac:	e204                	sd	s1,0(a2)
      return fd;
    800045ae:	b7f5                	j	8000459a <fdalloc+0x2c>

00000000800045b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045b0:	715d                	add	sp,sp,-80
    800045b2:	e486                	sd	ra,72(sp)
    800045b4:	e0a2                	sd	s0,64(sp)
    800045b6:	fc26                	sd	s1,56(sp)
    800045b8:	f84a                	sd	s2,48(sp)
    800045ba:	f44e                	sd	s3,40(sp)
    800045bc:	ec56                	sd	s5,24(sp)
    800045be:	e85a                	sd	s6,16(sp)
    800045c0:	0880                	add	s0,sp,80
    800045c2:	8b2e                	mv	s6,a1
    800045c4:	89b2                	mv	s3,a2
    800045c6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045c8:	fb040593          	add	a1,s0,-80
    800045cc:	fffff097          	auipc	ra,0xfffff
    800045d0:	de2080e7          	jalr	-542(ra) # 800033ae <nameiparent>
    800045d4:	84aa                	mv	s1,a0
    800045d6:	14050e63          	beqz	a0,80004732 <create+0x182>
    return 0;

  ilock(dp);
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	5e8080e7          	jalr	1512(ra) # 80002bc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045e2:	4601                	li	a2,0
    800045e4:	fb040593          	add	a1,s0,-80
    800045e8:	8526                	mv	a0,s1
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	ae4080e7          	jalr	-1308(ra) # 800030ce <dirlookup>
    800045f2:	8aaa                	mv	s5,a0
    800045f4:	c539                	beqz	a0,80004642 <create+0x92>
    iunlockput(dp);
    800045f6:	8526                	mv	a0,s1
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	830080e7          	jalr	-2000(ra) # 80002e28 <iunlockput>
    ilock(ip);
    80004600:	8556                	mv	a0,s5
    80004602:	ffffe097          	auipc	ra,0xffffe
    80004606:	5c0080e7          	jalr	1472(ra) # 80002bc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000460a:	4789                	li	a5,2
    8000460c:	02fb1463          	bne	s6,a5,80004634 <create+0x84>
    80004610:	044ad783          	lhu	a5,68(s5)
    80004614:	37f9                	addw	a5,a5,-2
    80004616:	17c2                	sll	a5,a5,0x30
    80004618:	93c1                	srl	a5,a5,0x30
    8000461a:	4705                	li	a4,1
    8000461c:	00f76c63          	bltu	a4,a5,80004634 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004620:	8556                	mv	a0,s5
    80004622:	60a6                	ld	ra,72(sp)
    80004624:	6406                	ld	s0,64(sp)
    80004626:	74e2                	ld	s1,56(sp)
    80004628:	7942                	ld	s2,48(sp)
    8000462a:	79a2                	ld	s3,40(sp)
    8000462c:	6ae2                	ld	s5,24(sp)
    8000462e:	6b42                	ld	s6,16(sp)
    80004630:	6161                	add	sp,sp,80
    80004632:	8082                	ret
    iunlockput(ip);
    80004634:	8556                	mv	a0,s5
    80004636:	ffffe097          	auipc	ra,0xffffe
    8000463a:	7f2080e7          	jalr	2034(ra) # 80002e28 <iunlockput>
    return 0;
    8000463e:	4a81                	li	s5,0
    80004640:	b7c5                	j	80004620 <create+0x70>
    80004642:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004644:	85da                	mv	a1,s6
    80004646:	4088                	lw	a0,0(s1)
    80004648:	ffffe097          	auipc	ra,0xffffe
    8000464c:	3d6080e7          	jalr	982(ra) # 80002a1e <ialloc>
    80004650:	8a2a                	mv	s4,a0
    80004652:	c531                	beqz	a0,8000469e <create+0xee>
  ilock(ip);
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	56e080e7          	jalr	1390(ra) # 80002bc2 <ilock>
  ip->major = major;
    8000465c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004660:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004664:	4905                	li	s2,1
    80004666:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000466a:	8552                	mv	a0,s4
    8000466c:	ffffe097          	auipc	ra,0xffffe
    80004670:	48a080e7          	jalr	1162(ra) # 80002af6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004674:	032b0d63          	beq	s6,s2,800046ae <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004678:	004a2603          	lw	a2,4(s4)
    8000467c:	fb040593          	add	a1,s0,-80
    80004680:	8526                	mv	a0,s1
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	c5c080e7          	jalr	-932(ra) # 800032de <dirlink>
    8000468a:	08054163          	bltz	a0,8000470c <create+0x15c>
  iunlockput(dp);
    8000468e:	8526                	mv	a0,s1
    80004690:	ffffe097          	auipc	ra,0xffffe
    80004694:	798080e7          	jalr	1944(ra) # 80002e28 <iunlockput>
  return ip;
    80004698:	8ad2                	mv	s5,s4
    8000469a:	7a02                	ld	s4,32(sp)
    8000469c:	b751                	j	80004620 <create+0x70>
    iunlockput(dp);
    8000469e:	8526                	mv	a0,s1
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	788080e7          	jalr	1928(ra) # 80002e28 <iunlockput>
    return 0;
    800046a8:	8ad2                	mv	s5,s4
    800046aa:	7a02                	ld	s4,32(sp)
    800046ac:	bf95                	j	80004620 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ae:	004a2603          	lw	a2,4(s4)
    800046b2:	00004597          	auipc	a1,0x4
    800046b6:	f0658593          	add	a1,a1,-250 # 800085b8 <etext+0x5b8>
    800046ba:	8552                	mv	a0,s4
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	c22080e7          	jalr	-990(ra) # 800032de <dirlink>
    800046c4:	04054463          	bltz	a0,8000470c <create+0x15c>
    800046c8:	40d0                	lw	a2,4(s1)
    800046ca:	00004597          	auipc	a1,0x4
    800046ce:	ef658593          	add	a1,a1,-266 # 800085c0 <etext+0x5c0>
    800046d2:	8552                	mv	a0,s4
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	c0a080e7          	jalr	-1014(ra) # 800032de <dirlink>
    800046dc:	02054863          	bltz	a0,8000470c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800046e0:	004a2603          	lw	a2,4(s4)
    800046e4:	fb040593          	add	a1,s0,-80
    800046e8:	8526                	mv	a0,s1
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	bf4080e7          	jalr	-1036(ra) # 800032de <dirlink>
    800046f2:	00054d63          	bltz	a0,8000470c <create+0x15c>
    dp->nlink++;  // for ".."
    800046f6:	04a4d783          	lhu	a5,74(s1)
    800046fa:	2785                	addw	a5,a5,1
    800046fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004700:	8526                	mv	a0,s1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	3f4080e7          	jalr	1012(ra) # 80002af6 <iupdate>
    8000470a:	b751                	j	8000468e <create+0xde>
  ip->nlink = 0;
    8000470c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004710:	8552                	mv	a0,s4
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	3e4080e7          	jalr	996(ra) # 80002af6 <iupdate>
  iunlockput(ip);
    8000471a:	8552                	mv	a0,s4
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	70c080e7          	jalr	1804(ra) # 80002e28 <iunlockput>
  iunlockput(dp);
    80004724:	8526                	mv	a0,s1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	702080e7          	jalr	1794(ra) # 80002e28 <iunlockput>
  return 0;
    8000472e:	7a02                	ld	s4,32(sp)
    80004730:	bdc5                	j	80004620 <create+0x70>
    return 0;
    80004732:	8aaa                	mv	s5,a0
    80004734:	b5f5                	j	80004620 <create+0x70>

0000000080004736 <sys_dup>:
{
    80004736:	7179                	add	sp,sp,-48
    80004738:	f406                	sd	ra,40(sp)
    8000473a:	f022                	sd	s0,32(sp)
    8000473c:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000473e:	fd840613          	add	a2,s0,-40
    80004742:	4581                	li	a1,0
    80004744:	4501                	li	a0,0
    80004746:	00000097          	auipc	ra,0x0
    8000474a:	dc8080e7          	jalr	-568(ra) # 8000450e <argfd>
    return -1;
    8000474e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004750:	02054763          	bltz	a0,8000477e <sys_dup+0x48>
    80004754:	ec26                	sd	s1,24(sp)
    80004756:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004758:	fd843903          	ld	s2,-40(s0)
    8000475c:	854a                	mv	a0,s2
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	e10080e7          	jalr	-496(ra) # 8000456e <fdalloc>
    80004766:	84aa                	mv	s1,a0
    return -1;
    80004768:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000476a:	00054f63          	bltz	a0,80004788 <sys_dup+0x52>
  filedup(f);
    8000476e:	854a                	mv	a0,s2
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	298080e7          	jalr	664(ra) # 80003a08 <filedup>
  return fd;
    80004778:	87a6                	mv	a5,s1
    8000477a:	64e2                	ld	s1,24(sp)
    8000477c:	6942                	ld	s2,16(sp)
}
    8000477e:	853e                	mv	a0,a5
    80004780:	70a2                	ld	ra,40(sp)
    80004782:	7402                	ld	s0,32(sp)
    80004784:	6145                	add	sp,sp,48
    80004786:	8082                	ret
    80004788:	64e2                	ld	s1,24(sp)
    8000478a:	6942                	ld	s2,16(sp)
    8000478c:	bfcd                	j	8000477e <sys_dup+0x48>

000000008000478e <sys_read>:
{
    8000478e:	7179                	add	sp,sp,-48
    80004790:	f406                	sd	ra,40(sp)
    80004792:	f022                	sd	s0,32(sp)
    80004794:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004796:	fd840593          	add	a1,s0,-40
    8000479a:	4505                	li	a0,1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	8ae080e7          	jalr	-1874(ra) # 8000204a <argaddr>
  argint(2, &n);
    800047a4:	fe440593          	add	a1,s0,-28
    800047a8:	4509                	li	a0,2
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	880080e7          	jalr	-1920(ra) # 8000202a <argint>
  if(argfd(0, 0, &f) < 0)
    800047b2:	fe840613          	add	a2,s0,-24
    800047b6:	4581                	li	a1,0
    800047b8:	4501                	li	a0,0
    800047ba:	00000097          	auipc	ra,0x0
    800047be:	d54080e7          	jalr	-684(ra) # 8000450e <argfd>
    800047c2:	87aa                	mv	a5,a0
    return -1;
    800047c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047c6:	0007cc63          	bltz	a5,800047de <sys_read+0x50>
  return fileread(f, p, n);
    800047ca:	fe442603          	lw	a2,-28(s0)
    800047ce:	fd843583          	ld	a1,-40(s0)
    800047d2:	fe843503          	ld	a0,-24(s0)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	3d8080e7          	jalr	984(ra) # 80003bae <fileread>
}
    800047de:	70a2                	ld	ra,40(sp)
    800047e0:	7402                	ld	s0,32(sp)
    800047e2:	6145                	add	sp,sp,48
    800047e4:	8082                	ret

00000000800047e6 <sys_write>:
{
    800047e6:	7179                	add	sp,sp,-48
    800047e8:	f406                	sd	ra,40(sp)
    800047ea:	f022                	sd	s0,32(sp)
    800047ec:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800047ee:	fd840593          	add	a1,s0,-40
    800047f2:	4505                	li	a0,1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	856080e7          	jalr	-1962(ra) # 8000204a <argaddr>
  argint(2, &n);
    800047fc:	fe440593          	add	a1,s0,-28
    80004800:	4509                	li	a0,2
    80004802:	ffffe097          	auipc	ra,0xffffe
    80004806:	828080e7          	jalr	-2008(ra) # 8000202a <argint>
  if(argfd(0, 0, &f) < 0)
    8000480a:	fe840613          	add	a2,s0,-24
    8000480e:	4581                	li	a1,0
    80004810:	4501                	li	a0,0
    80004812:	00000097          	auipc	ra,0x0
    80004816:	cfc080e7          	jalr	-772(ra) # 8000450e <argfd>
    8000481a:	87aa                	mv	a5,a0
    return -1;
    8000481c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000481e:	0007cc63          	bltz	a5,80004836 <sys_write+0x50>
  return filewrite(f, p, n);
    80004822:	fe442603          	lw	a2,-28(s0)
    80004826:	fd843583          	ld	a1,-40(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	452080e7          	jalr	1106(ra) # 80003c80 <filewrite>
}
    80004836:	70a2                	ld	ra,40(sp)
    80004838:	7402                	ld	s0,32(sp)
    8000483a:	6145                	add	sp,sp,48
    8000483c:	8082                	ret

000000008000483e <sys_close>:
{
    8000483e:	1101                	add	sp,sp,-32
    80004840:	ec06                	sd	ra,24(sp)
    80004842:	e822                	sd	s0,16(sp)
    80004844:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004846:	fe040613          	add	a2,s0,-32
    8000484a:	fec40593          	add	a1,s0,-20
    8000484e:	4501                	li	a0,0
    80004850:	00000097          	auipc	ra,0x0
    80004854:	cbe080e7          	jalr	-834(ra) # 8000450e <argfd>
    return -1;
    80004858:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000485a:	02054463          	bltz	a0,80004882 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000485e:	ffffc097          	auipc	ra,0xffffc
    80004862:	6a8080e7          	jalr	1704(ra) # 80000f06 <myproc>
    80004866:	fec42783          	lw	a5,-20(s0)
    8000486a:	07e9                	add	a5,a5,26
    8000486c:	078e                	sll	a5,a5,0x3
    8000486e:	953e                	add	a0,a0,a5
    80004870:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004874:	fe043503          	ld	a0,-32(s0)
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	1e2080e7          	jalr	482(ra) # 80003a5a <fileclose>
  return 0;
    80004880:	4781                	li	a5,0
}
    80004882:	853e                	mv	a0,a5
    80004884:	60e2                	ld	ra,24(sp)
    80004886:	6442                	ld	s0,16(sp)
    80004888:	6105                	add	sp,sp,32
    8000488a:	8082                	ret

000000008000488c <sys_fstat>:
{
    8000488c:	1101                	add	sp,sp,-32
    8000488e:	ec06                	sd	ra,24(sp)
    80004890:	e822                	sd	s0,16(sp)
    80004892:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004894:	fe040593          	add	a1,s0,-32
    80004898:	4505                	li	a0,1
    8000489a:	ffffd097          	auipc	ra,0xffffd
    8000489e:	7b0080e7          	jalr	1968(ra) # 8000204a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048a2:	fe840613          	add	a2,s0,-24
    800048a6:	4581                	li	a1,0
    800048a8:	4501                	li	a0,0
    800048aa:	00000097          	auipc	ra,0x0
    800048ae:	c64080e7          	jalr	-924(ra) # 8000450e <argfd>
    800048b2:	87aa                	mv	a5,a0
    return -1;
    800048b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048b6:	0007ca63          	bltz	a5,800048ca <sys_fstat+0x3e>
  return filestat(f, st);
    800048ba:	fe043583          	ld	a1,-32(s0)
    800048be:	fe843503          	ld	a0,-24(s0)
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	27a080e7          	jalr	634(ra) # 80003b3c <filestat>
}
    800048ca:	60e2                	ld	ra,24(sp)
    800048cc:	6442                	ld	s0,16(sp)
    800048ce:	6105                	add	sp,sp,32
    800048d0:	8082                	ret

00000000800048d2 <sys_link>:
{
    800048d2:	7169                	add	sp,sp,-304
    800048d4:	f606                	sd	ra,296(sp)
    800048d6:	f222                	sd	s0,288(sp)
    800048d8:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048da:	08000613          	li	a2,128
    800048de:	ed040593          	add	a1,s0,-304
    800048e2:	4501                	li	a0,0
    800048e4:	ffffd097          	auipc	ra,0xffffd
    800048e8:	786080e7          	jalr	1926(ra) # 8000206a <argstr>
    return -1;
    800048ec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ee:	12054663          	bltz	a0,80004a1a <sys_link+0x148>
    800048f2:	08000613          	li	a2,128
    800048f6:	f5040593          	add	a1,s0,-176
    800048fa:	4505                	li	a0,1
    800048fc:	ffffd097          	auipc	ra,0xffffd
    80004900:	76e080e7          	jalr	1902(ra) # 8000206a <argstr>
    return -1;
    80004904:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004906:	10054a63          	bltz	a0,80004a1a <sys_link+0x148>
    8000490a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	c84080e7          	jalr	-892(ra) # 80003590 <begin_op>
  if((ip = namei(old)) == 0){
    80004914:	ed040513          	add	a0,s0,-304
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	a78080e7          	jalr	-1416(ra) # 80003390 <namei>
    80004920:	84aa                	mv	s1,a0
    80004922:	c949                	beqz	a0,800049b4 <sys_link+0xe2>
  ilock(ip);
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	29e080e7          	jalr	670(ra) # 80002bc2 <ilock>
  if(ip->type == T_DIR){
    8000492c:	04449703          	lh	a4,68(s1)
    80004930:	4785                	li	a5,1
    80004932:	08f70863          	beq	a4,a5,800049c2 <sys_link+0xf0>
    80004936:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004938:	04a4d783          	lhu	a5,74(s1)
    8000493c:	2785                	addw	a5,a5,1
    8000493e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004942:	8526                	mv	a0,s1
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	1b2080e7          	jalr	434(ra) # 80002af6 <iupdate>
  iunlock(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	33a080e7          	jalr	826(ra) # 80002c88 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004956:	fd040593          	add	a1,s0,-48
    8000495a:	f5040513          	add	a0,s0,-176
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	a50080e7          	jalr	-1456(ra) # 800033ae <nameiparent>
    80004966:	892a                	mv	s2,a0
    80004968:	cd35                	beqz	a0,800049e4 <sys_link+0x112>
  ilock(dp);
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	258080e7          	jalr	600(ra) # 80002bc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004972:	00092703          	lw	a4,0(s2)
    80004976:	409c                	lw	a5,0(s1)
    80004978:	06f71163          	bne	a4,a5,800049da <sys_link+0x108>
    8000497c:	40d0                	lw	a2,4(s1)
    8000497e:	fd040593          	add	a1,s0,-48
    80004982:	854a                	mv	a0,s2
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	95a080e7          	jalr	-1702(ra) # 800032de <dirlink>
    8000498c:	04054763          	bltz	a0,800049da <sys_link+0x108>
  iunlockput(dp);
    80004990:	854a                	mv	a0,s2
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	496080e7          	jalr	1174(ra) # 80002e28 <iunlockput>
  iput(ip);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	3e4080e7          	jalr	996(ra) # 80002d80 <iput>
  end_op();
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	c66080e7          	jalr	-922(ra) # 8000360a <end_op>
  return 0;
    800049ac:	4781                	li	a5,0
    800049ae:	64f2                	ld	s1,280(sp)
    800049b0:	6952                	ld	s2,272(sp)
    800049b2:	a0a5                	j	80004a1a <sys_link+0x148>
    end_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	c56080e7          	jalr	-938(ra) # 8000360a <end_op>
    return -1;
    800049bc:	57fd                	li	a5,-1
    800049be:	64f2                	ld	s1,280(sp)
    800049c0:	a8a9                	j	80004a1a <sys_link+0x148>
    iunlockput(ip);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	464080e7          	jalr	1124(ra) # 80002e28 <iunlockput>
    end_op();
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	c3e080e7          	jalr	-962(ra) # 8000360a <end_op>
    return -1;
    800049d4:	57fd                	li	a5,-1
    800049d6:	64f2                	ld	s1,280(sp)
    800049d8:	a089                	j	80004a1a <sys_link+0x148>
    iunlockput(dp);
    800049da:	854a                	mv	a0,s2
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	44c080e7          	jalr	1100(ra) # 80002e28 <iunlockput>
  ilock(ip);
    800049e4:	8526                	mv	a0,s1
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	1dc080e7          	jalr	476(ra) # 80002bc2 <ilock>
  ip->nlink--;
    800049ee:	04a4d783          	lhu	a5,74(s1)
    800049f2:	37fd                	addw	a5,a5,-1
    800049f4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049f8:	8526                	mv	a0,s1
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	0fc080e7          	jalr	252(ra) # 80002af6 <iupdate>
  iunlockput(ip);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	424080e7          	jalr	1060(ra) # 80002e28 <iunlockput>
  end_op();
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	bfe080e7          	jalr	-1026(ra) # 8000360a <end_op>
  return -1;
    80004a14:	57fd                	li	a5,-1
    80004a16:	64f2                	ld	s1,280(sp)
    80004a18:	6952                	ld	s2,272(sp)
}
    80004a1a:	853e                	mv	a0,a5
    80004a1c:	70b2                	ld	ra,296(sp)
    80004a1e:	7412                	ld	s0,288(sp)
    80004a20:	6155                	add	sp,sp,304
    80004a22:	8082                	ret

0000000080004a24 <sys_unlink>:
{
    80004a24:	7151                	add	sp,sp,-240
    80004a26:	f586                	sd	ra,232(sp)
    80004a28:	f1a2                	sd	s0,224(sp)
    80004a2a:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a2c:	08000613          	li	a2,128
    80004a30:	f3040593          	add	a1,s0,-208
    80004a34:	4501                	li	a0,0
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	634080e7          	jalr	1588(ra) # 8000206a <argstr>
    80004a3e:	1a054a63          	bltz	a0,80004bf2 <sys_unlink+0x1ce>
    80004a42:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a44:	fffff097          	auipc	ra,0xfffff
    80004a48:	b4c080e7          	jalr	-1204(ra) # 80003590 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a4c:	fb040593          	add	a1,s0,-80
    80004a50:	f3040513          	add	a0,s0,-208
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	95a080e7          	jalr	-1702(ra) # 800033ae <nameiparent>
    80004a5c:	84aa                	mv	s1,a0
    80004a5e:	cd71                	beqz	a0,80004b3a <sys_unlink+0x116>
  ilock(dp);
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	162080e7          	jalr	354(ra) # 80002bc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a68:	00004597          	auipc	a1,0x4
    80004a6c:	b5058593          	add	a1,a1,-1200 # 800085b8 <etext+0x5b8>
    80004a70:	fb040513          	add	a0,s0,-80
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	640080e7          	jalr	1600(ra) # 800030b4 <namecmp>
    80004a7c:	14050c63          	beqz	a0,80004bd4 <sys_unlink+0x1b0>
    80004a80:	00004597          	auipc	a1,0x4
    80004a84:	b4058593          	add	a1,a1,-1216 # 800085c0 <etext+0x5c0>
    80004a88:	fb040513          	add	a0,s0,-80
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	628080e7          	jalr	1576(ra) # 800030b4 <namecmp>
    80004a94:	14050063          	beqz	a0,80004bd4 <sys_unlink+0x1b0>
    80004a98:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a9a:	f2c40613          	add	a2,s0,-212
    80004a9e:	fb040593          	add	a1,s0,-80
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	62a080e7          	jalr	1578(ra) # 800030ce <dirlookup>
    80004aac:	892a                	mv	s2,a0
    80004aae:	12050263          	beqz	a0,80004bd2 <sys_unlink+0x1ae>
  ilock(ip);
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	110080e7          	jalr	272(ra) # 80002bc2 <ilock>
  if(ip->nlink < 1)
    80004aba:	04a91783          	lh	a5,74(s2)
    80004abe:	08f05563          	blez	a5,80004b48 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ac2:	04491703          	lh	a4,68(s2)
    80004ac6:	4785                	li	a5,1
    80004ac8:	08f70963          	beq	a4,a5,80004b5a <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004acc:	4641                	li	a2,16
    80004ace:	4581                	li	a1,0
    80004ad0:	fc040513          	add	a0,s0,-64
    80004ad4:	ffffb097          	auipc	ra,0xffffb
    80004ad8:	6a6080e7          	jalr	1702(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004adc:	4741                	li	a4,16
    80004ade:	f2c42683          	lw	a3,-212(s0)
    80004ae2:	fc040613          	add	a2,s0,-64
    80004ae6:	4581                	li	a1,0
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	4a0080e7          	jalr	1184(ra) # 80002f8a <writei>
    80004af2:	47c1                	li	a5,16
    80004af4:	0af51b63          	bne	a0,a5,80004baa <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004af8:	04491703          	lh	a4,68(s2)
    80004afc:	4785                	li	a5,1
    80004afe:	0af70f63          	beq	a4,a5,80004bbc <sys_unlink+0x198>
  iunlockput(dp);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	324080e7          	jalr	804(ra) # 80002e28 <iunlockput>
  ip->nlink--;
    80004b0c:	04a95783          	lhu	a5,74(s2)
    80004b10:	37fd                	addw	a5,a5,-1
    80004b12:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b16:	854a                	mv	a0,s2
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	fde080e7          	jalr	-34(ra) # 80002af6 <iupdate>
  iunlockput(ip);
    80004b20:	854a                	mv	a0,s2
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	306080e7          	jalr	774(ra) # 80002e28 <iunlockput>
  end_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	ae0080e7          	jalr	-1312(ra) # 8000360a <end_op>
  return 0;
    80004b32:	4501                	li	a0,0
    80004b34:	64ee                	ld	s1,216(sp)
    80004b36:	694e                	ld	s2,208(sp)
    80004b38:	a84d                	j	80004bea <sys_unlink+0x1c6>
    end_op();
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	ad0080e7          	jalr	-1328(ra) # 8000360a <end_op>
    return -1;
    80004b42:	557d                	li	a0,-1
    80004b44:	64ee                	ld	s1,216(sp)
    80004b46:	a055                	j	80004bea <sys_unlink+0x1c6>
    80004b48:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b4a:	00004517          	auipc	a0,0x4
    80004b4e:	a7e50513          	add	a0,a0,-1410 # 800085c8 <etext+0x5c8>
    80004b52:	00001097          	auipc	ra,0x1
    80004b56:	240080e7          	jalr	576(ra) # 80005d92 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b5a:	04c92703          	lw	a4,76(s2)
    80004b5e:	02000793          	li	a5,32
    80004b62:	f6e7f5e3          	bgeu	a5,a4,80004acc <sys_unlink+0xa8>
    80004b66:	e5ce                	sd	s3,200(sp)
    80004b68:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b6c:	4741                	li	a4,16
    80004b6e:	86ce                	mv	a3,s3
    80004b70:	f1840613          	add	a2,s0,-232
    80004b74:	4581                	li	a1,0
    80004b76:	854a                	mv	a0,s2
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	302080e7          	jalr	770(ra) # 80002e7a <readi>
    80004b80:	47c1                	li	a5,16
    80004b82:	00f51c63          	bne	a0,a5,80004b9a <sys_unlink+0x176>
    if(de.inum != 0)
    80004b86:	f1845783          	lhu	a5,-232(s0)
    80004b8a:	e7b5                	bnez	a5,80004bf6 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b8c:	29c1                	addw	s3,s3,16
    80004b8e:	04c92783          	lw	a5,76(s2)
    80004b92:	fcf9ede3          	bltu	s3,a5,80004b6c <sys_unlink+0x148>
    80004b96:	69ae                	ld	s3,200(sp)
    80004b98:	bf15                	j	80004acc <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004b9a:	00004517          	auipc	a0,0x4
    80004b9e:	a4650513          	add	a0,a0,-1466 # 800085e0 <etext+0x5e0>
    80004ba2:	00001097          	auipc	ra,0x1
    80004ba6:	1f0080e7          	jalr	496(ra) # 80005d92 <panic>
    80004baa:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bac:	00004517          	auipc	a0,0x4
    80004bb0:	a4c50513          	add	a0,a0,-1460 # 800085f8 <etext+0x5f8>
    80004bb4:	00001097          	auipc	ra,0x1
    80004bb8:	1de080e7          	jalr	478(ra) # 80005d92 <panic>
    dp->nlink--;
    80004bbc:	04a4d783          	lhu	a5,74(s1)
    80004bc0:	37fd                	addw	a5,a5,-1
    80004bc2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	f2e080e7          	jalr	-210(ra) # 80002af6 <iupdate>
    80004bd0:	bf0d                	j	80004b02 <sys_unlink+0xde>
    80004bd2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	252080e7          	jalr	594(ra) # 80002e28 <iunlockput>
  end_op();
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	a2c080e7          	jalr	-1492(ra) # 8000360a <end_op>
  return -1;
    80004be6:	557d                	li	a0,-1
    80004be8:	64ee                	ld	s1,216(sp)
}
    80004bea:	70ae                	ld	ra,232(sp)
    80004bec:	740e                	ld	s0,224(sp)
    80004bee:	616d                	add	sp,sp,240
    80004bf0:	8082                	ret
    return -1;
    80004bf2:	557d                	li	a0,-1
    80004bf4:	bfdd                	j	80004bea <sys_unlink+0x1c6>
    iunlockput(ip);
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	230080e7          	jalr	560(ra) # 80002e28 <iunlockput>
    goto bad;
    80004c00:	694e                	ld	s2,208(sp)
    80004c02:	69ae                	ld	s3,200(sp)
    80004c04:	bfc1                	j	80004bd4 <sys_unlink+0x1b0>

0000000080004c06 <sys_open>:

uint64
sys_open(void)
{
    80004c06:	7131                	add	sp,sp,-192
    80004c08:	fd06                	sd	ra,184(sp)
    80004c0a:	f922                	sd	s0,176(sp)
    80004c0c:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c0e:	f4c40593          	add	a1,s0,-180
    80004c12:	4505                	li	a0,1
    80004c14:	ffffd097          	auipc	ra,0xffffd
    80004c18:	416080e7          	jalr	1046(ra) # 8000202a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c1c:	08000613          	li	a2,128
    80004c20:	f5040593          	add	a1,s0,-176
    80004c24:	4501                	li	a0,0
    80004c26:	ffffd097          	auipc	ra,0xffffd
    80004c2a:	444080e7          	jalr	1092(ra) # 8000206a <argstr>
    80004c2e:	87aa                	mv	a5,a0
    return -1;
    80004c30:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c32:	0a07ce63          	bltz	a5,80004cee <sys_open+0xe8>
    80004c36:	f526                	sd	s1,168(sp)

  begin_op();
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	958080e7          	jalr	-1704(ra) # 80003590 <begin_op>

  if(omode & O_CREATE){
    80004c40:	f4c42783          	lw	a5,-180(s0)
    80004c44:	2007f793          	and	a5,a5,512
    80004c48:	cfd5                	beqz	a5,80004d04 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c4a:	4681                	li	a3,0
    80004c4c:	4601                	li	a2,0
    80004c4e:	4589                	li	a1,2
    80004c50:	f5040513          	add	a0,s0,-176
    80004c54:	00000097          	auipc	ra,0x0
    80004c58:	95c080e7          	jalr	-1700(ra) # 800045b0 <create>
    80004c5c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c5e:	cd41                	beqz	a0,80004cf6 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c60:	04449703          	lh	a4,68(s1)
    80004c64:	478d                	li	a5,3
    80004c66:	00f71763          	bne	a4,a5,80004c74 <sys_open+0x6e>
    80004c6a:	0464d703          	lhu	a4,70(s1)
    80004c6e:	47a5                	li	a5,9
    80004c70:	0ee7e163          	bltu	a5,a4,80004d52 <sys_open+0x14c>
    80004c74:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	d28080e7          	jalr	-728(ra) # 8000399e <filealloc>
    80004c7e:	892a                	mv	s2,a0
    80004c80:	c97d                	beqz	a0,80004d76 <sys_open+0x170>
    80004c82:	ed4e                	sd	s3,152(sp)
    80004c84:	00000097          	auipc	ra,0x0
    80004c88:	8ea080e7          	jalr	-1814(ra) # 8000456e <fdalloc>
    80004c8c:	89aa                	mv	s3,a0
    80004c8e:	0c054e63          	bltz	a0,80004d6a <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c92:	04449703          	lh	a4,68(s1)
    80004c96:	478d                	li	a5,3
    80004c98:	0ef70c63          	beq	a4,a5,80004d90 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c9c:	4789                	li	a5,2
    80004c9e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ca2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004ca6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004caa:	f4c42783          	lw	a5,-180(s0)
    80004cae:	0017c713          	xor	a4,a5,1
    80004cb2:	8b05                	and	a4,a4,1
    80004cb4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cb8:	0037f713          	and	a4,a5,3
    80004cbc:	00e03733          	snez	a4,a4
    80004cc0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cc4:	4007f793          	and	a5,a5,1024
    80004cc8:	c791                	beqz	a5,80004cd4 <sys_open+0xce>
    80004cca:	04449703          	lh	a4,68(s1)
    80004cce:	4789                	li	a5,2
    80004cd0:	0cf70763          	beq	a4,a5,80004d9e <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004cd4:	8526                	mv	a0,s1
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	fb2080e7          	jalr	-78(ra) # 80002c88 <iunlock>
  end_op();
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	92c080e7          	jalr	-1748(ra) # 8000360a <end_op>

  return fd;
    80004ce6:	854e                	mv	a0,s3
    80004ce8:	74aa                	ld	s1,168(sp)
    80004cea:	790a                	ld	s2,160(sp)
    80004cec:	69ea                	ld	s3,152(sp)
}
    80004cee:	70ea                	ld	ra,184(sp)
    80004cf0:	744a                	ld	s0,176(sp)
    80004cf2:	6129                	add	sp,sp,192
    80004cf4:	8082                	ret
      end_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	914080e7          	jalr	-1772(ra) # 8000360a <end_op>
      return -1;
    80004cfe:	557d                	li	a0,-1
    80004d00:	74aa                	ld	s1,168(sp)
    80004d02:	b7f5                	j	80004cee <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004d04:	f5040513          	add	a0,s0,-176
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	688080e7          	jalr	1672(ra) # 80003390 <namei>
    80004d10:	84aa                	mv	s1,a0
    80004d12:	c90d                	beqz	a0,80004d44 <sys_open+0x13e>
    ilock(ip);
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	eae080e7          	jalr	-338(ra) # 80002bc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d1c:	04449703          	lh	a4,68(s1)
    80004d20:	4785                	li	a5,1
    80004d22:	f2f71fe3          	bne	a4,a5,80004c60 <sys_open+0x5a>
    80004d26:	f4c42783          	lw	a5,-180(s0)
    80004d2a:	d7a9                	beqz	a5,80004c74 <sys_open+0x6e>
      iunlockput(ip);
    80004d2c:	8526                	mv	a0,s1
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	0fa080e7          	jalr	250(ra) # 80002e28 <iunlockput>
      end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	8d4080e7          	jalr	-1836(ra) # 8000360a <end_op>
      return -1;
    80004d3e:	557d                	li	a0,-1
    80004d40:	74aa                	ld	s1,168(sp)
    80004d42:	b775                	j	80004cee <sys_open+0xe8>
      end_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	8c6080e7          	jalr	-1850(ra) # 8000360a <end_op>
      return -1;
    80004d4c:	557d                	li	a0,-1
    80004d4e:	74aa                	ld	s1,168(sp)
    80004d50:	bf79                	j	80004cee <sys_open+0xe8>
    iunlockput(ip);
    80004d52:	8526                	mv	a0,s1
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	0d4080e7          	jalr	212(ra) # 80002e28 <iunlockput>
    end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	8ae080e7          	jalr	-1874(ra) # 8000360a <end_op>
    return -1;
    80004d64:	557d                	li	a0,-1
    80004d66:	74aa                	ld	s1,168(sp)
    80004d68:	b759                	j	80004cee <sys_open+0xe8>
      fileclose(f);
    80004d6a:	854a                	mv	a0,s2
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	cee080e7          	jalr	-786(ra) # 80003a5a <fileclose>
    80004d74:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	0b0080e7          	jalr	176(ra) # 80002e28 <iunlockput>
    end_op();
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	88a080e7          	jalr	-1910(ra) # 8000360a <end_op>
    return -1;
    80004d88:	557d                	li	a0,-1
    80004d8a:	74aa                	ld	s1,168(sp)
    80004d8c:	790a                	ld	s2,160(sp)
    80004d8e:	b785                	j	80004cee <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004d90:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d94:	04649783          	lh	a5,70(s1)
    80004d98:	02f91223          	sh	a5,36(s2)
    80004d9c:	b729                	j	80004ca6 <sys_open+0xa0>
    itrunc(ip);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	f34080e7          	jalr	-204(ra) # 80002cd4 <itrunc>
    80004da8:	b735                	j	80004cd4 <sys_open+0xce>

0000000080004daa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004daa:	7175                	add	sp,sp,-144
    80004dac:	e506                	sd	ra,136(sp)
    80004dae:	e122                	sd	s0,128(sp)
    80004db0:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	7de080e7          	jalr	2014(ra) # 80003590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dba:	08000613          	li	a2,128
    80004dbe:	f7040593          	add	a1,s0,-144
    80004dc2:	4501                	li	a0,0
    80004dc4:	ffffd097          	auipc	ra,0xffffd
    80004dc8:	2a6080e7          	jalr	678(ra) # 8000206a <argstr>
    80004dcc:	02054963          	bltz	a0,80004dfe <sys_mkdir+0x54>
    80004dd0:	4681                	li	a3,0
    80004dd2:	4601                	li	a2,0
    80004dd4:	4585                	li	a1,1
    80004dd6:	f7040513          	add	a0,s0,-144
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	7d6080e7          	jalr	2006(ra) # 800045b0 <create>
    80004de2:	cd11                	beqz	a0,80004dfe <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	044080e7          	jalr	68(ra) # 80002e28 <iunlockput>
  end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	81e080e7          	jalr	-2018(ra) # 8000360a <end_op>
  return 0;
    80004df4:	4501                	li	a0,0
}
    80004df6:	60aa                	ld	ra,136(sp)
    80004df8:	640a                	ld	s0,128(sp)
    80004dfa:	6149                	add	sp,sp,144
    80004dfc:	8082                	ret
    end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	80c080e7          	jalr	-2036(ra) # 8000360a <end_op>
    return -1;
    80004e06:	557d                	li	a0,-1
    80004e08:	b7fd                	j	80004df6 <sys_mkdir+0x4c>

0000000080004e0a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e0a:	7135                	add	sp,sp,-160
    80004e0c:	ed06                	sd	ra,152(sp)
    80004e0e:	e922                	sd	s0,144(sp)
    80004e10:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	77e080e7          	jalr	1918(ra) # 80003590 <begin_op>
  argint(1, &major);
    80004e1a:	f6c40593          	add	a1,s0,-148
    80004e1e:	4505                	li	a0,1
    80004e20:	ffffd097          	auipc	ra,0xffffd
    80004e24:	20a080e7          	jalr	522(ra) # 8000202a <argint>
  argint(2, &minor);
    80004e28:	f6840593          	add	a1,s0,-152
    80004e2c:	4509                	li	a0,2
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	1fc080e7          	jalr	508(ra) # 8000202a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e36:	08000613          	li	a2,128
    80004e3a:	f7040593          	add	a1,s0,-144
    80004e3e:	4501                	li	a0,0
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	22a080e7          	jalr	554(ra) # 8000206a <argstr>
    80004e48:	02054b63          	bltz	a0,80004e7e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e4c:	f6841683          	lh	a3,-152(s0)
    80004e50:	f6c41603          	lh	a2,-148(s0)
    80004e54:	458d                	li	a1,3
    80004e56:	f7040513          	add	a0,s0,-144
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	756080e7          	jalr	1878(ra) # 800045b0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e62:	cd11                	beqz	a0,80004e7e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	fc4080e7          	jalr	-60(ra) # 80002e28 <iunlockput>
  end_op();
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	79e080e7          	jalr	1950(ra) # 8000360a <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
}
    80004e76:	60ea                	ld	ra,152(sp)
    80004e78:	644a                	ld	s0,144(sp)
    80004e7a:	610d                	add	sp,sp,160
    80004e7c:	8082                	ret
    end_op();
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	78c080e7          	jalr	1932(ra) # 8000360a <end_op>
    return -1;
    80004e86:	557d                	li	a0,-1
    80004e88:	b7fd                	j	80004e76 <sys_mknod+0x6c>

0000000080004e8a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e8a:	7135                	add	sp,sp,-160
    80004e8c:	ed06                	sd	ra,152(sp)
    80004e8e:	e922                	sd	s0,144(sp)
    80004e90:	e14a                	sd	s2,128(sp)
    80004e92:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e94:	ffffc097          	auipc	ra,0xffffc
    80004e98:	072080e7          	jalr	114(ra) # 80000f06 <myproc>
    80004e9c:	892a                	mv	s2,a0
  
  begin_op();
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	6f2080e7          	jalr	1778(ra) # 80003590 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ea6:	08000613          	li	a2,128
    80004eaa:	f6040593          	add	a1,s0,-160
    80004eae:	4501                	li	a0,0
    80004eb0:	ffffd097          	auipc	ra,0xffffd
    80004eb4:	1ba080e7          	jalr	442(ra) # 8000206a <argstr>
    80004eb8:	04054d63          	bltz	a0,80004f12 <sys_chdir+0x88>
    80004ebc:	e526                	sd	s1,136(sp)
    80004ebe:	f6040513          	add	a0,s0,-160
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	4ce080e7          	jalr	1230(ra) # 80003390 <namei>
    80004eca:	84aa                	mv	s1,a0
    80004ecc:	c131                	beqz	a0,80004f10 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	cf4080e7          	jalr	-780(ra) # 80002bc2 <ilock>
  if(ip->type != T_DIR){
    80004ed6:	04449703          	lh	a4,68(s1)
    80004eda:	4785                	li	a5,1
    80004edc:	04f71163          	bne	a4,a5,80004f1e <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ee0:	8526                	mv	a0,s1
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	da6080e7          	jalr	-602(ra) # 80002c88 <iunlock>
  iput(p->cwd);
    80004eea:	15093503          	ld	a0,336(s2)
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	e92080e7          	jalr	-366(ra) # 80002d80 <iput>
  end_op();
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	714080e7          	jalr	1812(ra) # 8000360a <end_op>
  p->cwd = ip;
    80004efe:	14993823          	sd	s1,336(s2)
  return 0;
    80004f02:	4501                	li	a0,0
    80004f04:	64aa                	ld	s1,136(sp)
}
    80004f06:	60ea                	ld	ra,152(sp)
    80004f08:	644a                	ld	s0,144(sp)
    80004f0a:	690a                	ld	s2,128(sp)
    80004f0c:	610d                	add	sp,sp,160
    80004f0e:	8082                	ret
    80004f10:	64aa                	ld	s1,136(sp)
    end_op();
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	6f8080e7          	jalr	1784(ra) # 8000360a <end_op>
    return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	b7ed                	j	80004f06 <sys_chdir+0x7c>
    iunlockput(ip);
    80004f1e:	8526                	mv	a0,s1
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	f08080e7          	jalr	-248(ra) # 80002e28 <iunlockput>
    end_op();
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	6e2080e7          	jalr	1762(ra) # 8000360a <end_op>
    return -1;
    80004f30:	557d                	li	a0,-1
    80004f32:	64aa                	ld	s1,136(sp)
    80004f34:	bfc9                	j	80004f06 <sys_chdir+0x7c>

0000000080004f36 <sys_exec>:

uint64
sys_exec(void)
{
    80004f36:	7121                	add	sp,sp,-448
    80004f38:	ff06                	sd	ra,440(sp)
    80004f3a:	fb22                	sd	s0,432(sp)
    80004f3c:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f3e:	e4840593          	add	a1,s0,-440
    80004f42:	4505                	li	a0,1
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	106080e7          	jalr	262(ra) # 8000204a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f4c:	08000613          	li	a2,128
    80004f50:	f5040593          	add	a1,s0,-176
    80004f54:	4501                	li	a0,0
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	114080e7          	jalr	276(ra) # 8000206a <argstr>
    80004f5e:	87aa                	mv	a5,a0
    return -1;
    80004f60:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f62:	0e07c263          	bltz	a5,80005046 <sys_exec+0x110>
    80004f66:	f726                	sd	s1,424(sp)
    80004f68:	f34a                	sd	s2,416(sp)
    80004f6a:	ef4e                	sd	s3,408(sp)
    80004f6c:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f6e:	10000613          	li	a2,256
    80004f72:	4581                	li	a1,0
    80004f74:	e5040513          	add	a0,s0,-432
    80004f78:	ffffb097          	auipc	ra,0xffffb
    80004f7c:	202080e7          	jalr	514(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f80:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f84:	89a6                	mv	s3,s1
    80004f86:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f88:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f8c:	00391513          	sll	a0,s2,0x3
    80004f90:	e4040593          	add	a1,s0,-448
    80004f94:	e4843783          	ld	a5,-440(s0)
    80004f98:	953e                	add	a0,a0,a5
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	ff2080e7          	jalr	-14(ra) # 80001f8c <fetchaddr>
    80004fa2:	02054a63          	bltz	a0,80004fd6 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004fa6:	e4043783          	ld	a5,-448(s0)
    80004faa:	c7b9                	beqz	a5,80004ff8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fac:	ffffb097          	auipc	ra,0xffffb
    80004fb0:	16e080e7          	jalr	366(ra) # 8000011a <kalloc>
    80004fb4:	85aa                	mv	a1,a0
    80004fb6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fba:	cd11                	beqz	a0,80004fd6 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fbc:	6605                	lui	a2,0x1
    80004fbe:	e4043503          	ld	a0,-448(s0)
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	01c080e7          	jalr	28(ra) # 80001fde <fetchstr>
    80004fca:	00054663          	bltz	a0,80004fd6 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004fce:	0905                	add	s2,s2,1
    80004fd0:	09a1                	add	s3,s3,8
    80004fd2:	fb491de3          	bne	s2,s4,80004f8c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd6:	f5040913          	add	s2,s0,-176
    80004fda:	6088                	ld	a0,0(s1)
    80004fdc:	c125                	beqz	a0,8000503c <sys_exec+0x106>
    kfree(argv[i]);
    80004fde:	ffffb097          	auipc	ra,0xffffb
    80004fe2:	03e080e7          	jalr	62(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe6:	04a1                	add	s1,s1,8
    80004fe8:	ff2499e3          	bne	s1,s2,80004fda <sys_exec+0xa4>
  return -1;
    80004fec:	557d                	li	a0,-1
    80004fee:	74ba                	ld	s1,424(sp)
    80004ff0:	791a                	ld	s2,416(sp)
    80004ff2:	69fa                	ld	s3,408(sp)
    80004ff4:	6a5a                	ld	s4,400(sp)
    80004ff6:	a881                	j	80005046 <sys_exec+0x110>
      argv[i] = 0;
    80004ff8:	0009079b          	sext.w	a5,s2
    80004ffc:	078e                	sll	a5,a5,0x3
    80004ffe:	fd078793          	add	a5,a5,-48
    80005002:	97a2                	add	a5,a5,s0
    80005004:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005008:	e5040593          	add	a1,s0,-432
    8000500c:	f5040513          	add	a0,s0,-176
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	120080e7          	jalr	288(ra) # 80004130 <exec>
    80005018:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501a:	f5040993          	add	s3,s0,-176
    8000501e:	6088                	ld	a0,0(s1)
    80005020:	c901                	beqz	a0,80005030 <sys_exec+0xfa>
    kfree(argv[i]);
    80005022:	ffffb097          	auipc	ra,0xffffb
    80005026:	ffa080e7          	jalr	-6(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000502a:	04a1                	add	s1,s1,8
    8000502c:	ff3499e3          	bne	s1,s3,8000501e <sys_exec+0xe8>
  return ret;
    80005030:	854a                	mv	a0,s2
    80005032:	74ba                	ld	s1,424(sp)
    80005034:	791a                	ld	s2,416(sp)
    80005036:	69fa                	ld	s3,408(sp)
    80005038:	6a5a                	ld	s4,400(sp)
    8000503a:	a031                	j	80005046 <sys_exec+0x110>
  return -1;
    8000503c:	557d                	li	a0,-1
    8000503e:	74ba                	ld	s1,424(sp)
    80005040:	791a                	ld	s2,416(sp)
    80005042:	69fa                	ld	s3,408(sp)
    80005044:	6a5a                	ld	s4,400(sp)
}
    80005046:	70fa                	ld	ra,440(sp)
    80005048:	745a                	ld	s0,432(sp)
    8000504a:	6139                	add	sp,sp,448
    8000504c:	8082                	ret

000000008000504e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000504e:	7139                	add	sp,sp,-64
    80005050:	fc06                	sd	ra,56(sp)
    80005052:	f822                	sd	s0,48(sp)
    80005054:	f426                	sd	s1,40(sp)
    80005056:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005058:	ffffc097          	auipc	ra,0xffffc
    8000505c:	eae080e7          	jalr	-338(ra) # 80000f06 <myproc>
    80005060:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005062:	fd840593          	add	a1,s0,-40
    80005066:	4501                	li	a0,0
    80005068:	ffffd097          	auipc	ra,0xffffd
    8000506c:	fe2080e7          	jalr	-30(ra) # 8000204a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005070:	fc840593          	add	a1,s0,-56
    80005074:	fd040513          	add	a0,s0,-48
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	d50080e7          	jalr	-688(ra) # 80003dc8 <pipealloc>
    return -1;
    80005080:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005082:	0c054463          	bltz	a0,8000514a <sys_pipe+0xfc>
  fd0 = -1;
    80005086:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000508a:	fd043503          	ld	a0,-48(s0)
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	4e0080e7          	jalr	1248(ra) # 8000456e <fdalloc>
    80005096:	fca42223          	sw	a0,-60(s0)
    8000509a:	08054b63          	bltz	a0,80005130 <sys_pipe+0xe2>
    8000509e:	fc843503          	ld	a0,-56(s0)
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	4cc080e7          	jalr	1228(ra) # 8000456e <fdalloc>
    800050aa:	fca42023          	sw	a0,-64(s0)
    800050ae:	06054863          	bltz	a0,8000511e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050b2:	4691                	li	a3,4
    800050b4:	fc440613          	add	a2,s0,-60
    800050b8:	fd843583          	ld	a1,-40(s0)
    800050bc:	68a8                	ld	a0,80(s1)
    800050be:	ffffc097          	auipc	ra,0xffffc
    800050c2:	a8e080e7          	jalr	-1394(ra) # 80000b4c <copyout>
    800050c6:	02054063          	bltz	a0,800050e6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ca:	4691                	li	a3,4
    800050cc:	fc040613          	add	a2,s0,-64
    800050d0:	fd843583          	ld	a1,-40(s0)
    800050d4:	0591                	add	a1,a1,4
    800050d6:	68a8                	ld	a0,80(s1)
    800050d8:	ffffc097          	auipc	ra,0xffffc
    800050dc:	a74080e7          	jalr	-1420(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050e0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050e2:	06055463          	bgez	a0,8000514a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050e6:	fc442783          	lw	a5,-60(s0)
    800050ea:	07e9                	add	a5,a5,26
    800050ec:	078e                	sll	a5,a5,0x3
    800050ee:	97a6                	add	a5,a5,s1
    800050f0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050f4:	fc042783          	lw	a5,-64(s0)
    800050f8:	07e9                	add	a5,a5,26
    800050fa:	078e                	sll	a5,a5,0x3
    800050fc:	94be                	add	s1,s1,a5
    800050fe:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005102:	fd043503          	ld	a0,-48(s0)
    80005106:	fffff097          	auipc	ra,0xfffff
    8000510a:	954080e7          	jalr	-1708(ra) # 80003a5a <fileclose>
    fileclose(wf);
    8000510e:	fc843503          	ld	a0,-56(s0)
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	948080e7          	jalr	-1720(ra) # 80003a5a <fileclose>
    return -1;
    8000511a:	57fd                	li	a5,-1
    8000511c:	a03d                	j	8000514a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000511e:	fc442783          	lw	a5,-60(s0)
    80005122:	0007c763          	bltz	a5,80005130 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005126:	07e9                	add	a5,a5,26
    80005128:	078e                	sll	a5,a5,0x3
    8000512a:	97a6                	add	a5,a5,s1
    8000512c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005130:	fd043503          	ld	a0,-48(s0)
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	926080e7          	jalr	-1754(ra) # 80003a5a <fileclose>
    fileclose(wf);
    8000513c:	fc843503          	ld	a0,-56(s0)
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	91a080e7          	jalr	-1766(ra) # 80003a5a <fileclose>
    return -1;
    80005148:	57fd                	li	a5,-1
}
    8000514a:	853e                	mv	a0,a5
    8000514c:	70e2                	ld	ra,56(sp)
    8000514e:	7442                	ld	s0,48(sp)
    80005150:	74a2                	ld	s1,40(sp)
    80005152:	6121                	add	sp,sp,64
    80005154:	8082                	ret
	...

0000000080005160 <kernelvec>:
    80005160:	7111                	add	sp,sp,-256
    80005162:	e006                	sd	ra,0(sp)
    80005164:	e40a                	sd	sp,8(sp)
    80005166:	e80e                	sd	gp,16(sp)
    80005168:	ec12                	sd	tp,24(sp)
    8000516a:	f016                	sd	t0,32(sp)
    8000516c:	f41a                	sd	t1,40(sp)
    8000516e:	f81e                	sd	t2,48(sp)
    80005170:	fc22                	sd	s0,56(sp)
    80005172:	e0a6                	sd	s1,64(sp)
    80005174:	e4aa                	sd	a0,72(sp)
    80005176:	e8ae                	sd	a1,80(sp)
    80005178:	ecb2                	sd	a2,88(sp)
    8000517a:	f0b6                	sd	a3,96(sp)
    8000517c:	f4ba                	sd	a4,104(sp)
    8000517e:	f8be                	sd	a5,112(sp)
    80005180:	fcc2                	sd	a6,120(sp)
    80005182:	e146                	sd	a7,128(sp)
    80005184:	e54a                	sd	s2,136(sp)
    80005186:	e94e                	sd	s3,144(sp)
    80005188:	ed52                	sd	s4,152(sp)
    8000518a:	f156                	sd	s5,160(sp)
    8000518c:	f55a                	sd	s6,168(sp)
    8000518e:	f95e                	sd	s7,176(sp)
    80005190:	fd62                	sd	s8,184(sp)
    80005192:	e1e6                	sd	s9,192(sp)
    80005194:	e5ea                	sd	s10,200(sp)
    80005196:	e9ee                	sd	s11,208(sp)
    80005198:	edf2                	sd	t3,216(sp)
    8000519a:	f1f6                	sd	t4,224(sp)
    8000519c:	f5fa                	sd	t5,232(sp)
    8000519e:	f9fe                	sd	t6,240(sp)
    800051a0:	cb9fc0ef          	jal	80001e58 <kerneltrap>
    800051a4:	6082                	ld	ra,0(sp)
    800051a6:	6122                	ld	sp,8(sp)
    800051a8:	61c2                	ld	gp,16(sp)
    800051aa:	7282                	ld	t0,32(sp)
    800051ac:	7322                	ld	t1,40(sp)
    800051ae:	73c2                	ld	t2,48(sp)
    800051b0:	7462                	ld	s0,56(sp)
    800051b2:	6486                	ld	s1,64(sp)
    800051b4:	6526                	ld	a0,72(sp)
    800051b6:	65c6                	ld	a1,80(sp)
    800051b8:	6666                	ld	a2,88(sp)
    800051ba:	7686                	ld	a3,96(sp)
    800051bc:	7726                	ld	a4,104(sp)
    800051be:	77c6                	ld	a5,112(sp)
    800051c0:	7866                	ld	a6,120(sp)
    800051c2:	688a                	ld	a7,128(sp)
    800051c4:	692a                	ld	s2,136(sp)
    800051c6:	69ca                	ld	s3,144(sp)
    800051c8:	6a6a                	ld	s4,152(sp)
    800051ca:	7a8a                	ld	s5,160(sp)
    800051cc:	7b2a                	ld	s6,168(sp)
    800051ce:	7bca                	ld	s7,176(sp)
    800051d0:	7c6a                	ld	s8,184(sp)
    800051d2:	6c8e                	ld	s9,192(sp)
    800051d4:	6d2e                	ld	s10,200(sp)
    800051d6:	6dce                	ld	s11,208(sp)
    800051d8:	6e6e                	ld	t3,216(sp)
    800051da:	7e8e                	ld	t4,224(sp)
    800051dc:	7f2e                	ld	t5,232(sp)
    800051de:	7fce                	ld	t6,240(sp)
    800051e0:	6111                	add	sp,sp,256
    800051e2:	10200073          	sret
    800051e6:	00000013          	nop
    800051ea:	00000013          	nop
    800051ee:	0001                	nop

00000000800051f0 <timervec>:
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	e10c                	sd	a1,0(a0)
    800051f6:	e510                	sd	a2,8(a0)
    800051f8:	e914                	sd	a3,16(a0)
    800051fa:	6d0c                	ld	a1,24(a0)
    800051fc:	7110                	ld	a2,32(a0)
    800051fe:	6194                	ld	a3,0(a1)
    80005200:	96b2                	add	a3,a3,a2
    80005202:	e194                	sd	a3,0(a1)
    80005204:	4589                	li	a1,2
    80005206:	14459073          	csrw	sip,a1
    8000520a:	6914                	ld	a3,16(a0)
    8000520c:	6510                	ld	a2,8(a0)
    8000520e:	610c                	ld	a1,0(a0)
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	30200073          	mret
	...

000000008000521a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000521a:	1141                	add	sp,sp,-16
    8000521c:	e422                	sd	s0,8(sp)
    8000521e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005220:	0c0007b7          	lui	a5,0xc000
    80005224:	4705                	li	a4,1
    80005226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005228:	0c0007b7          	lui	a5,0xc000
    8000522c:	c3d8                	sw	a4,4(a5)
}
    8000522e:	6422                	ld	s0,8(sp)
    80005230:	0141                	add	sp,sp,16
    80005232:	8082                	ret

0000000080005234 <plicinithart>:

void
plicinithart(void)
{
    80005234:	1141                	add	sp,sp,-16
    80005236:	e406                	sd	ra,8(sp)
    80005238:	e022                	sd	s0,0(sp)
    8000523a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000523c:	ffffc097          	auipc	ra,0xffffc
    80005240:	c9e080e7          	jalr	-866(ra) # 80000eda <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005244:	0085171b          	sllw	a4,a0,0x8
    80005248:	0c0027b7          	lui	a5,0xc002
    8000524c:	97ba                	add	a5,a5,a4
    8000524e:	40200713          	li	a4,1026
    80005252:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005256:	00d5151b          	sllw	a0,a0,0xd
    8000525a:	0c2017b7          	lui	a5,0xc201
    8000525e:	97aa                	add	a5,a5,a0
    80005260:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005264:	60a2                	ld	ra,8(sp)
    80005266:	6402                	ld	s0,0(sp)
    80005268:	0141                	add	sp,sp,16
    8000526a:	8082                	ret

000000008000526c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000526c:	1141                	add	sp,sp,-16
    8000526e:	e406                	sd	ra,8(sp)
    80005270:	e022                	sd	s0,0(sp)
    80005272:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005274:	ffffc097          	auipc	ra,0xffffc
    80005278:	c66080e7          	jalr	-922(ra) # 80000eda <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000527c:	00d5151b          	sllw	a0,a0,0xd
    80005280:	0c2017b7          	lui	a5,0xc201
    80005284:	97aa                	add	a5,a5,a0
  return irq;
}
    80005286:	43c8                	lw	a0,4(a5)
    80005288:	60a2                	ld	ra,8(sp)
    8000528a:	6402                	ld	s0,0(sp)
    8000528c:	0141                	add	sp,sp,16
    8000528e:	8082                	ret

0000000080005290 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005290:	1101                	add	sp,sp,-32
    80005292:	ec06                	sd	ra,24(sp)
    80005294:	e822                	sd	s0,16(sp)
    80005296:	e426                	sd	s1,8(sp)
    80005298:	1000                	add	s0,sp,32
    8000529a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000529c:	ffffc097          	auipc	ra,0xffffc
    800052a0:	c3e080e7          	jalr	-962(ra) # 80000eda <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052a4:	00d5151b          	sllw	a0,a0,0xd
    800052a8:	0c2017b7          	lui	a5,0xc201
    800052ac:	97aa                	add	a5,a5,a0
    800052ae:	c3c4                	sw	s1,4(a5)
}
    800052b0:	60e2                	ld	ra,24(sp)
    800052b2:	6442                	ld	s0,16(sp)
    800052b4:	64a2                	ld	s1,8(sp)
    800052b6:	6105                	add	sp,sp,32
    800052b8:	8082                	ret

00000000800052ba <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052ba:	1141                	add	sp,sp,-16
    800052bc:	e406                	sd	ra,8(sp)
    800052be:	e022                	sd	s0,0(sp)
    800052c0:	0800                	add	s0,sp,16
  if(i >= NUM)
    800052c2:	479d                	li	a5,7
    800052c4:	04a7cc63          	blt	a5,a0,8000531c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052c8:	00014797          	auipc	a5,0x14
    800052cc:	72878793          	add	a5,a5,1832 # 800199f0 <disk>
    800052d0:	97aa                	add	a5,a5,a0
    800052d2:	0187c783          	lbu	a5,24(a5)
    800052d6:	ebb9                	bnez	a5,8000532c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052d8:	00451693          	sll	a3,a0,0x4
    800052dc:	00014797          	auipc	a5,0x14
    800052e0:	71478793          	add	a5,a5,1812 # 800199f0 <disk>
    800052e4:	6398                	ld	a4,0(a5)
    800052e6:	9736                	add	a4,a4,a3
    800052e8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052ec:	6398                	ld	a4,0(a5)
    800052ee:	9736                	add	a4,a4,a3
    800052f0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052f4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052f8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052fc:	97aa                	add	a5,a5,a0
    800052fe:	4705                	li	a4,1
    80005300:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005304:	00014517          	auipc	a0,0x14
    80005308:	70450513          	add	a0,a0,1796 # 80019a08 <disk+0x18>
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	30c080e7          	jalr	780(ra) # 80001618 <wakeup>
}
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	add	sp,sp,16
    8000531a:	8082                	ret
    panic("free_desc 1");
    8000531c:	00003517          	auipc	a0,0x3
    80005320:	2ec50513          	add	a0,a0,748 # 80008608 <etext+0x608>
    80005324:	00001097          	auipc	ra,0x1
    80005328:	a6e080e7          	jalr	-1426(ra) # 80005d92 <panic>
    panic("free_desc 2");
    8000532c:	00003517          	auipc	a0,0x3
    80005330:	2ec50513          	add	a0,a0,748 # 80008618 <etext+0x618>
    80005334:	00001097          	auipc	ra,0x1
    80005338:	a5e080e7          	jalr	-1442(ra) # 80005d92 <panic>

000000008000533c <virtio_disk_init>:
{
    8000533c:	1101                	add	sp,sp,-32
    8000533e:	ec06                	sd	ra,24(sp)
    80005340:	e822                	sd	s0,16(sp)
    80005342:	e426                	sd	s1,8(sp)
    80005344:	e04a                	sd	s2,0(sp)
    80005346:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005348:	00003597          	auipc	a1,0x3
    8000534c:	2e058593          	add	a1,a1,736 # 80008628 <etext+0x628>
    80005350:	00014517          	auipc	a0,0x14
    80005354:	7c850513          	add	a0,a0,1992 # 80019b18 <disk+0x128>
    80005358:	00001097          	auipc	ra,0x1
    8000535c:	f24080e7          	jalr	-220(ra) # 8000627c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005360:	100017b7          	lui	a5,0x10001
    80005364:	4398                	lw	a4,0(a5)
    80005366:	2701                	sext.w	a4,a4
    80005368:	747277b7          	lui	a5,0x74727
    8000536c:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005370:	18f71c63          	bne	a4,a5,80005508 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000537a:	439c                	lw	a5,0(a5)
    8000537c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000537e:	4709                	li	a4,2
    80005380:	18e79463          	bne	a5,a4,80005508 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005384:	100017b7          	lui	a5,0x10001
    80005388:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000538a:	439c                	lw	a5,0(a5)
    8000538c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000538e:	16e79d63          	bne	a5,a4,80005508 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005392:	100017b7          	lui	a5,0x10001
    80005396:	47d8                	lw	a4,12(a5)
    80005398:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000539a:	554d47b7          	lui	a5,0x554d4
    8000539e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053a2:	16f71363          	bne	a4,a5,80005508 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a6:	100017b7          	lui	a5,0x10001
    800053aa:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ae:	4705                	li	a4,1
    800053b0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b2:	470d                	li	a4,3
    800053b4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053b6:	10001737          	lui	a4,0x10001
    800053ba:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053bc:	c7ffe737          	lui	a4,0xc7ffe
    800053c0:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053c4:	8ef9                	and	a3,a3,a4
    800053c6:	10001737          	lui	a4,0x10001
    800053ca:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053cc:	472d                	li	a4,11
    800053ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d0:	07078793          	add	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800053d4:	439c                	lw	a5,0(a5)
    800053d6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053da:	8ba1                	and	a5,a5,8
    800053dc:	12078e63          	beqz	a5,80005518 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053e0:	100017b7          	lui	a5,0x10001
    800053e4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	04478793          	add	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800053f0:	439c                	lw	a5,0(a5)
    800053f2:	2781                	sext.w	a5,a5
    800053f4:	12079a63          	bnez	a5,80005528 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005400:	439c                	lw	a5,0(a5)
    80005402:	2781                	sext.w	a5,a5
  if(max == 0)
    80005404:	12078a63          	beqz	a5,80005538 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005408:	471d                	li	a4,7
    8000540a:	12f77f63          	bgeu	a4,a5,80005548 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000540e:	ffffb097          	auipc	ra,0xffffb
    80005412:	d0c080e7          	jalr	-756(ra) # 8000011a <kalloc>
    80005416:	00014497          	auipc	s1,0x14
    8000541a:	5da48493          	add	s1,s1,1498 # 800199f0 <disk>
    8000541e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005420:	ffffb097          	auipc	ra,0xffffb
    80005424:	cfa080e7          	jalr	-774(ra) # 8000011a <kalloc>
    80005428:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000542a:	ffffb097          	auipc	ra,0xffffb
    8000542e:	cf0080e7          	jalr	-784(ra) # 8000011a <kalloc>
    80005432:	87aa                	mv	a5,a0
    80005434:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005436:	6088                	ld	a0,0(s1)
    80005438:	12050063          	beqz	a0,80005558 <virtio_disk_init+0x21c>
    8000543c:	00014717          	auipc	a4,0x14
    80005440:	5bc73703          	ld	a4,1468(a4) # 800199f8 <disk+0x8>
    80005444:	10070a63          	beqz	a4,80005558 <virtio_disk_init+0x21c>
    80005448:	10078863          	beqz	a5,80005558 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000544c:	6605                	lui	a2,0x1
    8000544e:	4581                	li	a1,0
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	d2a080e7          	jalr	-726(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005458:	00014497          	auipc	s1,0x14
    8000545c:	59848493          	add	s1,s1,1432 # 800199f0 <disk>
    80005460:	6605                	lui	a2,0x1
    80005462:	4581                	li	a1,0
    80005464:	6488                	ld	a0,8(s1)
    80005466:	ffffb097          	auipc	ra,0xffffb
    8000546a:	d14080e7          	jalr	-748(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    8000546e:	6605                	lui	a2,0x1
    80005470:	4581                	li	a1,0
    80005472:	6888                	ld	a0,16(s1)
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d06080e7          	jalr	-762(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000547c:	100017b7          	lui	a5,0x10001
    80005480:	4721                	li	a4,8
    80005482:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005484:	4098                	lw	a4,0(s1)
    80005486:	100017b7          	lui	a5,0x10001
    8000548a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000548e:	40d8                	lw	a4,4(s1)
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005498:	649c                	ld	a5,8(s1)
    8000549a:	0007869b          	sext.w	a3,a5
    8000549e:	10001737          	lui	a4,0x10001
    800054a2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054a6:	9781                	sra	a5,a5,0x20
    800054a8:	10001737          	lui	a4,0x10001
    800054ac:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054b0:	689c                	ld	a5,16(s1)
    800054b2:	0007869b          	sext.w	a3,a5
    800054b6:	10001737          	lui	a4,0x10001
    800054ba:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054be:	9781                	sra	a5,a5,0x20
    800054c0:	10001737          	lui	a4,0x10001
    800054c4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054c8:	10001737          	lui	a4,0x10001
    800054cc:	4785                	li	a5,1
    800054ce:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800054d0:	00f48c23          	sb	a5,24(s1)
    800054d4:	00f48ca3          	sb	a5,25(s1)
    800054d8:	00f48d23          	sb	a5,26(s1)
    800054dc:	00f48da3          	sb	a5,27(s1)
    800054e0:	00f48e23          	sb	a5,28(s1)
    800054e4:	00f48ea3          	sb	a5,29(s1)
    800054e8:	00f48f23          	sb	a5,30(s1)
    800054ec:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054f0:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6902                	ld	s2,0(sp)
    80005504:	6105                	add	sp,sp,32
    80005506:	8082                	ret
    panic("could not find virtio disk");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	13050513          	add	a0,a0,304 # 80008638 <etext+0x638>
    80005510:	00001097          	auipc	ra,0x1
    80005514:	882080e7          	jalr	-1918(ra) # 80005d92 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005518:	00003517          	auipc	a0,0x3
    8000551c:	14050513          	add	a0,a0,320 # 80008658 <etext+0x658>
    80005520:	00001097          	auipc	ra,0x1
    80005524:	872080e7          	jalr	-1934(ra) # 80005d92 <panic>
    panic("virtio disk should not be ready");
    80005528:	00003517          	auipc	a0,0x3
    8000552c:	15050513          	add	a0,a0,336 # 80008678 <etext+0x678>
    80005530:	00001097          	auipc	ra,0x1
    80005534:	862080e7          	jalr	-1950(ra) # 80005d92 <panic>
    panic("virtio disk has no queue 0");
    80005538:	00003517          	auipc	a0,0x3
    8000553c:	16050513          	add	a0,a0,352 # 80008698 <etext+0x698>
    80005540:	00001097          	auipc	ra,0x1
    80005544:	852080e7          	jalr	-1966(ra) # 80005d92 <panic>
    panic("virtio disk max queue too short");
    80005548:	00003517          	auipc	a0,0x3
    8000554c:	17050513          	add	a0,a0,368 # 800086b8 <etext+0x6b8>
    80005550:	00001097          	auipc	ra,0x1
    80005554:	842080e7          	jalr	-1982(ra) # 80005d92 <panic>
    panic("virtio disk kalloc");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	18050513          	add	a0,a0,384 # 800086d8 <etext+0x6d8>
    80005560:	00001097          	auipc	ra,0x1
    80005564:	832080e7          	jalr	-1998(ra) # 80005d92 <panic>

0000000080005568 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005568:	7159                	add	sp,sp,-112
    8000556a:	f486                	sd	ra,104(sp)
    8000556c:	f0a2                	sd	s0,96(sp)
    8000556e:	eca6                	sd	s1,88(sp)
    80005570:	e8ca                	sd	s2,80(sp)
    80005572:	e4ce                	sd	s3,72(sp)
    80005574:	e0d2                	sd	s4,64(sp)
    80005576:	fc56                	sd	s5,56(sp)
    80005578:	f85a                	sd	s6,48(sp)
    8000557a:	f45e                	sd	s7,40(sp)
    8000557c:	f062                	sd	s8,32(sp)
    8000557e:	ec66                	sd	s9,24(sp)
    80005580:	1880                	add	s0,sp,112
    80005582:	8a2a                	mv	s4,a0
    80005584:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005586:	00c52c83          	lw	s9,12(a0)
    8000558a:	001c9c9b          	sllw	s9,s9,0x1
    8000558e:	1c82                	sll	s9,s9,0x20
    80005590:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005594:	00014517          	auipc	a0,0x14
    80005598:	58450513          	add	a0,a0,1412 # 80019b18 <disk+0x128>
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	d70080e7          	jalr	-656(ra) # 8000630c <acquire>
  for(int i = 0; i < 3; i++){
    800055a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055a8:	00014b17          	auipc	s6,0x14
    800055ac:	448b0b13          	add	s6,s6,1096 # 800199f0 <disk>
  for(int i = 0; i < 3; i++){
    800055b0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b2:	00014c17          	auipc	s8,0x14
    800055b6:	566c0c13          	add	s8,s8,1382 # 80019b18 <disk+0x128>
    800055ba:	a0ad                	j	80005624 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800055bc:	00fb0733          	add	a4,s6,a5
    800055c0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800055c4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055c6:	0207c563          	bltz	a5,800055f0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055ca:	2905                	addw	s2,s2,1
    800055cc:	0611                	add	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055ce:	05590f63          	beq	s2,s5,8000562c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800055d2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055d4:	00014717          	auipc	a4,0x14
    800055d8:	41c70713          	add	a4,a4,1052 # 800199f0 <disk>
    800055dc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055de:	01874683          	lbu	a3,24(a4)
    800055e2:	fee9                	bnez	a3,800055bc <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800055e4:	2785                	addw	a5,a5,1
    800055e6:	0705                	add	a4,a4,1
    800055e8:	fe979be3          	bne	a5,s1,800055de <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ec:	57fd                	li	a5,-1
    800055ee:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055f0:	03205163          	blez	s2,80005612 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800055f4:	f9042503          	lw	a0,-112(s0)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	cc2080e7          	jalr	-830(ra) # 800052ba <free_desc>
      for(int j = 0; j < i; j++)
    80005600:	4785                	li	a5,1
    80005602:	0127d863          	bge	a5,s2,80005612 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005606:	f9442503          	lw	a0,-108(s0)
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	cb0080e7          	jalr	-848(ra) # 800052ba <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005612:	85e2                	mv	a1,s8
    80005614:	00014517          	auipc	a0,0x14
    80005618:	3f450513          	add	a0,a0,1012 # 80019a08 <disk+0x18>
    8000561c:	ffffc097          	auipc	ra,0xffffc
    80005620:	f98080e7          	jalr	-104(ra) # 800015b4 <sleep>
  for(int i = 0; i < 3; i++){
    80005624:	f9040613          	add	a2,s0,-112
    80005628:	894e                	mv	s2,s3
    8000562a:	b765                	j	800055d2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000562c:	f9042503          	lw	a0,-112(s0)
    80005630:	00451693          	sll	a3,a0,0x4

  if(write)
    80005634:	00014797          	auipc	a5,0x14
    80005638:	3bc78793          	add	a5,a5,956 # 800199f0 <disk>
    8000563c:	00a50713          	add	a4,a0,10
    80005640:	0712                	sll	a4,a4,0x4
    80005642:	973e                	add	a4,a4,a5
    80005644:	01703633          	snez	a2,s7
    80005648:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000564a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000564e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005652:	6398                	ld	a4,0(a5)
    80005654:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005656:	0a868613          	add	a2,a3,168
    8000565a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000565c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000565e:	6390                	ld	a2,0(a5)
    80005660:	00d605b3          	add	a1,a2,a3
    80005664:	4741                	li	a4,16
    80005666:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005668:	4805                	li	a6,1
    8000566a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000566e:	f9442703          	lw	a4,-108(s0)
    80005672:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005676:	0712                	sll	a4,a4,0x4
    80005678:	963a                	add	a2,a2,a4
    8000567a:	058a0593          	add	a1,s4,88
    8000567e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005680:	0007b883          	ld	a7,0(a5)
    80005684:	9746                	add	a4,a4,a7
    80005686:	40000613          	li	a2,1024
    8000568a:	c710                	sw	a2,8(a4)
  if(write)
    8000568c:	001bb613          	seqz	a2,s7
    80005690:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005694:	00166613          	or	a2,a2,1
    80005698:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000569c:	f9842583          	lw	a1,-104(s0)
    800056a0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056a4:	00250613          	add	a2,a0,2
    800056a8:	0612                	sll	a2,a2,0x4
    800056aa:	963e                	add	a2,a2,a5
    800056ac:	577d                	li	a4,-1
    800056ae:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056b2:	0592                	sll	a1,a1,0x4
    800056b4:	98ae                	add	a7,a7,a1
    800056b6:	03068713          	add	a4,a3,48
    800056ba:	973e                	add	a4,a4,a5
    800056bc:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800056c0:	6398                	ld	a4,0(a5)
    800056c2:	972e                	add	a4,a4,a1
    800056c4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056c8:	4689                	li	a3,2
    800056ca:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800056ce:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800056d6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056da:	6794                	ld	a3,8(a5)
    800056dc:	0026d703          	lhu	a4,2(a3)
    800056e0:	8b1d                	and	a4,a4,7
    800056e2:	0706                	sll	a4,a4,0x1
    800056e4:	96ba                	add	a3,a3,a4
    800056e6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056ea:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ee:	6798                	ld	a4,8(a5)
    800056f0:	00275783          	lhu	a5,2(a4)
    800056f4:	2785                	addw	a5,a5,1
    800056f6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056fa:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fe:	100017b7          	lui	a5,0x10001
    80005702:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005706:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000570a:	00014917          	auipc	s2,0x14
    8000570e:	40e90913          	add	s2,s2,1038 # 80019b18 <disk+0x128>
  while(b->disk == 1) {
    80005712:	4485                	li	s1,1
    80005714:	01079c63          	bne	a5,a6,8000572c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005718:	85ca                	mv	a1,s2
    8000571a:	8552                	mv	a0,s4
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	e98080e7          	jalr	-360(ra) # 800015b4 <sleep>
  while(b->disk == 1) {
    80005724:	004a2783          	lw	a5,4(s4)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	00290713          	add	a4,s2,2
    80005734:	0712                	sll	a4,a4,0x4
    80005736:	00014797          	auipc	a5,0x14
    8000573a:	2ba78793          	add	a5,a5,698 # 800199f0 <disk>
    8000573e:	97ba                	add	a5,a5,a4
    80005740:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005744:	00014997          	auipc	s3,0x14
    80005748:	2ac98993          	add	s3,s3,684 # 800199f0 <disk>
    8000574c:	00491713          	sll	a4,s2,0x4
    80005750:	0009b783          	ld	a5,0(s3)
    80005754:	97ba                	add	a5,a5,a4
    80005756:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575a:	854a                	mv	a0,s2
    8000575c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005760:	00000097          	auipc	ra,0x0
    80005764:	b5a080e7          	jalr	-1190(ra) # 800052ba <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005768:	8885                	and	s1,s1,1
    8000576a:	f0ed                	bnez	s1,8000574c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576c:	00014517          	auipc	a0,0x14
    80005770:	3ac50513          	add	a0,a0,940 # 80019b18 <disk+0x128>
    80005774:	00001097          	auipc	ra,0x1
    80005778:	c4c080e7          	jalr	-948(ra) # 800063c0 <release>
}
    8000577c:	70a6                	ld	ra,104(sp)
    8000577e:	7406                	ld	s0,96(sp)
    80005780:	64e6                	ld	s1,88(sp)
    80005782:	6946                	ld	s2,80(sp)
    80005784:	69a6                	ld	s3,72(sp)
    80005786:	6a06                	ld	s4,64(sp)
    80005788:	7ae2                	ld	s5,56(sp)
    8000578a:	7b42                	ld	s6,48(sp)
    8000578c:	7ba2                	ld	s7,40(sp)
    8000578e:	7c02                	ld	s8,32(sp)
    80005790:	6ce2                	ld	s9,24(sp)
    80005792:	6165                	add	sp,sp,112
    80005794:	8082                	ret

0000000080005796 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005796:	1101                	add	sp,sp,-32
    80005798:	ec06                	sd	ra,24(sp)
    8000579a:	e822                	sd	s0,16(sp)
    8000579c:	e426                	sd	s1,8(sp)
    8000579e:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a0:	00014497          	auipc	s1,0x14
    800057a4:	25048493          	add	s1,s1,592 # 800199f0 <disk>
    800057a8:	00014517          	auipc	a0,0x14
    800057ac:	37050513          	add	a0,a0,880 # 80019b18 <disk+0x128>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	b5c080e7          	jalr	-1188(ra) # 8000630c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b8:	100017b7          	lui	a5,0x10001
    800057bc:	53b8                	lw	a4,96(a5)
    800057be:	8b0d                	and	a4,a4,3
    800057c0:	100017b7          	lui	a5,0x10001
    800057c4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057c6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057ca:	689c                	ld	a5,16(s1)
    800057cc:	0204d703          	lhu	a4,32(s1)
    800057d0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800057d4:	04f70863          	beq	a4,a5,80005824 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800057d8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057dc:	6898                	ld	a4,16(s1)
    800057de:	0204d783          	lhu	a5,32(s1)
    800057e2:	8b9d                	and	a5,a5,7
    800057e4:	078e                	sll	a5,a5,0x3
    800057e6:	97ba                	add	a5,a5,a4
    800057e8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ea:	00278713          	add	a4,a5,2
    800057ee:	0712                	sll	a4,a4,0x4
    800057f0:	9726                	add	a4,a4,s1
    800057f2:	01074703          	lbu	a4,16(a4)
    800057f6:	e721                	bnez	a4,8000583e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057f8:	0789                	add	a5,a5,2
    800057fa:	0792                	sll	a5,a5,0x4
    800057fc:	97a6                	add	a5,a5,s1
    800057fe:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005800:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005804:	ffffc097          	auipc	ra,0xffffc
    80005808:	e14080e7          	jalr	-492(ra) # 80001618 <wakeup>

    disk.used_idx += 1;
    8000580c:	0204d783          	lhu	a5,32(s1)
    80005810:	2785                	addw	a5,a5,1
    80005812:	17c2                	sll	a5,a5,0x30
    80005814:	93c1                	srl	a5,a5,0x30
    80005816:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000581a:	6898                	ld	a4,16(s1)
    8000581c:	00275703          	lhu	a4,2(a4)
    80005820:	faf71ce3          	bne	a4,a5,800057d8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005824:	00014517          	auipc	a0,0x14
    80005828:	2f450513          	add	a0,a0,756 # 80019b18 <disk+0x128>
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	b94080e7          	jalr	-1132(ra) # 800063c0 <release>
}
    80005834:	60e2                	ld	ra,24(sp)
    80005836:	6442                	ld	s0,16(sp)
    80005838:	64a2                	ld	s1,8(sp)
    8000583a:	6105                	add	sp,sp,32
    8000583c:	8082                	ret
      panic("virtio_disk_intr status");
    8000583e:	00003517          	auipc	a0,0x3
    80005842:	eb250513          	add	a0,a0,-334 # 800086f0 <etext+0x6f0>
    80005846:	00000097          	auipc	ra,0x0
    8000584a:	54c080e7          	jalr	1356(ra) # 80005d92 <panic>

000000008000584e <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000584e:	1141                	add	sp,sp,-16
    80005850:	e422                	sd	s0,8(sp)
    80005852:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005854:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005858:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000585c:	0037979b          	sllw	a5,a5,0x3
    80005860:	02004737          	lui	a4,0x2004
    80005864:	97ba                	add	a5,a5,a4
    80005866:	0200c737          	lui	a4,0x200c
    8000586a:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000586c:	6318                	ld	a4,0(a4)
    8000586e:	000f4637          	lui	a2,0xf4
    80005872:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005876:	9732                	add	a4,a4,a2
    80005878:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000587a:	00259693          	sll	a3,a1,0x2
    8000587e:	96ae                	add	a3,a3,a1
    80005880:	068e                	sll	a3,a3,0x3
    80005882:	00014717          	auipc	a4,0x14
    80005886:	2ae70713          	add	a4,a4,686 # 80019b30 <timer_scratch>
    8000588a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000588c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000588e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005890:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005894:	00000797          	auipc	a5,0x0
    80005898:	95c78793          	add	a5,a5,-1700 # 800051f0 <timervec>
    8000589c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058a0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058a4:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058ac:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058b0:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058b4:	30479073          	csrw	mie,a5
}
    800058b8:	6422                	ld	s0,8(sp)
    800058ba:	0141                	add	sp,sp,16
    800058bc:	8082                	ret

00000000800058be <start>:
{
    800058be:	1141                	add	sp,sp,-16
    800058c0:	e406                	sd	ra,8(sp)
    800058c2:	e022                	sd	s0,0(sp)
    800058c4:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058c6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058ca:	7779                	lui	a4,0xffffe
    800058cc:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca8f>
    800058d0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058d2:	6705                	lui	a4,0x1
    800058d4:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058da:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058de:	ffffb797          	auipc	a5,0xffffb
    800058e2:	a3a78793          	add	a5,a5,-1478 # 80000318 <main>
    800058e6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ea:	4781                	li	a5,0
    800058ec:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058f0:	67c1                	lui	a5,0x10
    800058f2:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058f4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058f8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058fc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005900:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005904:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005908:	57fd                	li	a5,-1
    8000590a:	83a9                	srl	a5,a5,0xa
    8000590c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005910:	47bd                	li	a5,15
    80005912:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	f38080e7          	jalr	-200(ra) # 8000584e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000591e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005922:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005924:	823e                	mv	tp,a5
  asm volatile("mret");
    80005926:	30200073          	mret
}
    8000592a:	60a2                	ld	ra,8(sp)
    8000592c:	6402                	ld	s0,0(sp)
    8000592e:	0141                	add	sp,sp,16
    80005930:	8082                	ret

0000000080005932 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005932:	715d                	add	sp,sp,-80
    80005934:	e486                	sd	ra,72(sp)
    80005936:	e0a2                	sd	s0,64(sp)
    80005938:	f84a                	sd	s2,48(sp)
    8000593a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000593c:	04c05663          	blez	a2,80005988 <consolewrite+0x56>
    80005940:	fc26                	sd	s1,56(sp)
    80005942:	f44e                	sd	s3,40(sp)
    80005944:	f052                	sd	s4,32(sp)
    80005946:	ec56                	sd	s5,24(sp)
    80005948:	8a2a                	mv	s4,a0
    8000594a:	84ae                	mv	s1,a1
    8000594c:	89b2                	mv	s3,a2
    8000594e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005950:	5afd                	li	s5,-1
    80005952:	4685                	li	a3,1
    80005954:	8626                	mv	a2,s1
    80005956:	85d2                	mv	a1,s4
    80005958:	fbf40513          	add	a0,s0,-65
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	0b6080e7          	jalr	182(ra) # 80001a12 <either_copyin>
    80005964:	03550463          	beq	a0,s5,8000598c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005968:	fbf44503          	lbu	a0,-65(s0)
    8000596c:	00000097          	auipc	ra,0x0
    80005970:	7e4080e7          	jalr	2020(ra) # 80006150 <uartputc>
  for(i = 0; i < n; i++){
    80005974:	2905                	addw	s2,s2,1
    80005976:	0485                	add	s1,s1,1
    80005978:	fd299de3          	bne	s3,s2,80005952 <consolewrite+0x20>
    8000597c:	894e                	mv	s2,s3
    8000597e:	74e2                	ld	s1,56(sp)
    80005980:	79a2                	ld	s3,40(sp)
    80005982:	7a02                	ld	s4,32(sp)
    80005984:	6ae2                	ld	s5,24(sp)
    80005986:	a039                	j	80005994 <consolewrite+0x62>
    80005988:	4901                	li	s2,0
    8000598a:	a029                	j	80005994 <consolewrite+0x62>
    8000598c:	74e2                	ld	s1,56(sp)
    8000598e:	79a2                	ld	s3,40(sp)
    80005990:	7a02                	ld	s4,32(sp)
    80005992:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005994:	854a                	mv	a0,s2
    80005996:	60a6                	ld	ra,72(sp)
    80005998:	6406                	ld	s0,64(sp)
    8000599a:	7942                	ld	s2,48(sp)
    8000599c:	6161                	add	sp,sp,80
    8000599e:	8082                	ret

00000000800059a0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059a0:	711d                	add	sp,sp,-96
    800059a2:	ec86                	sd	ra,88(sp)
    800059a4:	e8a2                	sd	s0,80(sp)
    800059a6:	e4a6                	sd	s1,72(sp)
    800059a8:	e0ca                	sd	s2,64(sp)
    800059aa:	fc4e                	sd	s3,56(sp)
    800059ac:	f852                	sd	s4,48(sp)
    800059ae:	f456                	sd	s5,40(sp)
    800059b0:	f05a                	sd	s6,32(sp)
    800059b2:	1080                	add	s0,sp,96
    800059b4:	8aaa                	mv	s5,a0
    800059b6:	8a2e                	mv	s4,a1
    800059b8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ba:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059be:	0001c517          	auipc	a0,0x1c
    800059c2:	2b250513          	add	a0,a0,690 # 80021c70 <cons>
    800059c6:	00001097          	auipc	ra,0x1
    800059ca:	946080e7          	jalr	-1722(ra) # 8000630c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ce:	0001c497          	auipc	s1,0x1c
    800059d2:	2a248493          	add	s1,s1,674 # 80021c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059d6:	0001c917          	auipc	s2,0x1c
    800059da:	33290913          	add	s2,s2,818 # 80021d08 <cons+0x98>
  while(n > 0){
    800059de:	0d305763          	blez	s3,80005aac <consoleread+0x10c>
    while(cons.r == cons.w){
    800059e2:	0984a783          	lw	a5,152(s1)
    800059e6:	09c4a703          	lw	a4,156(s1)
    800059ea:	0af71c63          	bne	a4,a5,80005aa2 <consoleread+0x102>
      if(killed(myproc())){
    800059ee:	ffffb097          	auipc	ra,0xffffb
    800059f2:	518080e7          	jalr	1304(ra) # 80000f06 <myproc>
    800059f6:	ffffc097          	auipc	ra,0xffffc
    800059fa:	e66080e7          	jalr	-410(ra) # 8000185c <killed>
    800059fe:	e52d                	bnez	a0,80005a68 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005a00:	85a6                	mv	a1,s1
    80005a02:	854a                	mv	a0,s2
    80005a04:	ffffc097          	auipc	ra,0xffffc
    80005a08:	bb0080e7          	jalr	-1104(ra) # 800015b4 <sleep>
    while(cons.r == cons.w){
    80005a0c:	0984a783          	lw	a5,152(s1)
    80005a10:	09c4a703          	lw	a4,156(s1)
    80005a14:	fcf70de3          	beq	a4,a5,800059ee <consoleread+0x4e>
    80005a18:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a1a:	0001c717          	auipc	a4,0x1c
    80005a1e:	25670713          	add	a4,a4,598 # 80021c70 <cons>
    80005a22:	0017869b          	addw	a3,a5,1
    80005a26:	08d72c23          	sw	a3,152(a4)
    80005a2a:	07f7f693          	and	a3,a5,127
    80005a2e:	9736                	add	a4,a4,a3
    80005a30:	01874703          	lbu	a4,24(a4)
    80005a34:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a38:	4691                	li	a3,4
    80005a3a:	04db8a63          	beq	s7,a3,80005a8e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a3e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a42:	4685                	li	a3,1
    80005a44:	faf40613          	add	a2,s0,-81
    80005a48:	85d2                	mv	a1,s4
    80005a4a:	8556                	mv	a0,s5
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	f70080e7          	jalr	-144(ra) # 800019bc <either_copyout>
    80005a54:	57fd                	li	a5,-1
    80005a56:	04f50a63          	beq	a0,a5,80005aaa <consoleread+0x10a>
      break;

    dst++;
    80005a5a:	0a05                	add	s4,s4,1
    --n;
    80005a5c:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005a5e:	47a9                	li	a5,10
    80005a60:	06fb8163          	beq	s7,a5,80005ac2 <consoleread+0x122>
    80005a64:	6be2                	ld	s7,24(sp)
    80005a66:	bfa5                	j	800059de <consoleread+0x3e>
        release(&cons.lock);
    80005a68:	0001c517          	auipc	a0,0x1c
    80005a6c:	20850513          	add	a0,a0,520 # 80021c70 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	950080e7          	jalr	-1712(ra) # 800063c0 <release>
        return -1;
    80005a78:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a7a:	60e6                	ld	ra,88(sp)
    80005a7c:	6446                	ld	s0,80(sp)
    80005a7e:	64a6                	ld	s1,72(sp)
    80005a80:	6906                	ld	s2,64(sp)
    80005a82:	79e2                	ld	s3,56(sp)
    80005a84:	7a42                	ld	s4,48(sp)
    80005a86:	7aa2                	ld	s5,40(sp)
    80005a88:	7b02                	ld	s6,32(sp)
    80005a8a:	6125                	add	sp,sp,96
    80005a8c:	8082                	ret
      if(n < target){
    80005a8e:	0009871b          	sext.w	a4,s3
    80005a92:	01677a63          	bgeu	a4,s6,80005aa6 <consoleread+0x106>
        cons.r--;
    80005a96:	0001c717          	auipc	a4,0x1c
    80005a9a:	26f72923          	sw	a5,626(a4) # 80021d08 <cons+0x98>
    80005a9e:	6be2                	ld	s7,24(sp)
    80005aa0:	a031                	j	80005aac <consoleread+0x10c>
    80005aa2:	ec5e                	sd	s7,24(sp)
    80005aa4:	bf9d                	j	80005a1a <consoleread+0x7a>
    80005aa6:	6be2                	ld	s7,24(sp)
    80005aa8:	a011                	j	80005aac <consoleread+0x10c>
    80005aaa:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005aac:	0001c517          	auipc	a0,0x1c
    80005ab0:	1c450513          	add	a0,a0,452 # 80021c70 <cons>
    80005ab4:	00001097          	auipc	ra,0x1
    80005ab8:	90c080e7          	jalr	-1780(ra) # 800063c0 <release>
  return target - n;
    80005abc:	413b053b          	subw	a0,s6,s3
    80005ac0:	bf6d                	j	80005a7a <consoleread+0xda>
    80005ac2:	6be2                	ld	s7,24(sp)
    80005ac4:	b7e5                	j	80005aac <consoleread+0x10c>

0000000080005ac6 <consputc>:
{
    80005ac6:	1141                	add	sp,sp,-16
    80005ac8:	e406                	sd	ra,8(sp)
    80005aca:	e022                	sd	s0,0(sp)
    80005acc:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005ace:	10000793          	li	a5,256
    80005ad2:	00f50a63          	beq	a0,a5,80005ae6 <consputc+0x20>
    uartputc_sync(c);
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	59c080e7          	jalr	1436(ra) # 80006072 <uartputc_sync>
}
    80005ade:	60a2                	ld	ra,8(sp)
    80005ae0:	6402                	ld	s0,0(sp)
    80005ae2:	0141                	add	sp,sp,16
    80005ae4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae6:	4521                	li	a0,8
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	58a080e7          	jalr	1418(ra) # 80006072 <uartputc_sync>
    80005af0:	02000513          	li	a0,32
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	57e080e7          	jalr	1406(ra) # 80006072 <uartputc_sync>
    80005afc:	4521                	li	a0,8
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	574080e7          	jalr	1396(ra) # 80006072 <uartputc_sync>
    80005b06:	bfe1                	j	80005ade <consputc+0x18>

0000000080005b08 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b08:	1101                	add	sp,sp,-32
    80005b0a:	ec06                	sd	ra,24(sp)
    80005b0c:	e822                	sd	s0,16(sp)
    80005b0e:	e426                	sd	s1,8(sp)
    80005b10:	1000                	add	s0,sp,32
    80005b12:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b14:	0001c517          	auipc	a0,0x1c
    80005b18:	15c50513          	add	a0,a0,348 # 80021c70 <cons>
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	7f0080e7          	jalr	2032(ra) # 8000630c <acquire>

  switch(c){
    80005b24:	47d5                	li	a5,21
    80005b26:	0af48563          	beq	s1,a5,80005bd0 <consoleintr+0xc8>
    80005b2a:	0297c963          	blt	a5,s1,80005b5c <consoleintr+0x54>
    80005b2e:	47a1                	li	a5,8
    80005b30:	0ef48c63          	beq	s1,a5,80005c28 <consoleintr+0x120>
    80005b34:	47c1                	li	a5,16
    80005b36:	10f49f63          	bne	s1,a5,80005c54 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b3a:	ffffc097          	auipc	ra,0xffffc
    80005b3e:	f2e080e7          	jalr	-210(ra) # 80001a68 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b42:	0001c517          	auipc	a0,0x1c
    80005b46:	12e50513          	add	a0,a0,302 # 80021c70 <cons>
    80005b4a:	00001097          	auipc	ra,0x1
    80005b4e:	876080e7          	jalr	-1930(ra) # 800063c0 <release>
}
    80005b52:	60e2                	ld	ra,24(sp)
    80005b54:	6442                	ld	s0,16(sp)
    80005b56:	64a2                	ld	s1,8(sp)
    80005b58:	6105                	add	sp,sp,32
    80005b5a:	8082                	ret
  switch(c){
    80005b5c:	07f00793          	li	a5,127
    80005b60:	0cf48463          	beq	s1,a5,80005c28 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b64:	0001c717          	auipc	a4,0x1c
    80005b68:	10c70713          	add	a4,a4,268 # 80021c70 <cons>
    80005b6c:	0a072783          	lw	a5,160(a4)
    80005b70:	09872703          	lw	a4,152(a4)
    80005b74:	9f99                	subw	a5,a5,a4
    80005b76:	07f00713          	li	a4,127
    80005b7a:	fcf764e3          	bltu	a4,a5,80005b42 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b7e:	47b5                	li	a5,13
    80005b80:	0cf48d63          	beq	s1,a5,80005c5a <consoleintr+0x152>
      consputc(c);
    80005b84:	8526                	mv	a0,s1
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	f40080e7          	jalr	-192(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b8e:	0001c797          	auipc	a5,0x1c
    80005b92:	0e278793          	add	a5,a5,226 # 80021c70 <cons>
    80005b96:	0a07a683          	lw	a3,160(a5)
    80005b9a:	0016871b          	addw	a4,a3,1
    80005b9e:	0007061b          	sext.w	a2,a4
    80005ba2:	0ae7a023          	sw	a4,160(a5)
    80005ba6:	07f6f693          	and	a3,a3,127
    80005baa:	97b6                	add	a5,a5,a3
    80005bac:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005bb0:	47a9                	li	a5,10
    80005bb2:	0cf48b63          	beq	s1,a5,80005c88 <consoleintr+0x180>
    80005bb6:	4791                	li	a5,4
    80005bb8:	0cf48863          	beq	s1,a5,80005c88 <consoleintr+0x180>
    80005bbc:	0001c797          	auipc	a5,0x1c
    80005bc0:	14c7a783          	lw	a5,332(a5) # 80021d08 <cons+0x98>
    80005bc4:	9f1d                	subw	a4,a4,a5
    80005bc6:	08000793          	li	a5,128
    80005bca:	f6f71ce3          	bne	a4,a5,80005b42 <consoleintr+0x3a>
    80005bce:	a86d                	j	80005c88 <consoleintr+0x180>
    80005bd0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bd2:	0001c717          	auipc	a4,0x1c
    80005bd6:	09e70713          	add	a4,a4,158 # 80021c70 <cons>
    80005bda:	0a072783          	lw	a5,160(a4)
    80005bde:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005be2:	0001c497          	auipc	s1,0x1c
    80005be6:	08e48493          	add	s1,s1,142 # 80021c70 <cons>
    while(cons.e != cons.w &&
    80005bea:	4929                	li	s2,10
    80005bec:	02f70a63          	beq	a4,a5,80005c20 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bf0:	37fd                	addw	a5,a5,-1
    80005bf2:	07f7f713          	and	a4,a5,127
    80005bf6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf8:	01874703          	lbu	a4,24(a4)
    80005bfc:	03270463          	beq	a4,s2,80005c24 <consoleintr+0x11c>
      cons.e--;
    80005c00:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c04:	10000513          	li	a0,256
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	ebe080e7          	jalr	-322(ra) # 80005ac6 <consputc>
    while(cons.e != cons.w &&
    80005c10:	0a04a783          	lw	a5,160(s1)
    80005c14:	09c4a703          	lw	a4,156(s1)
    80005c18:	fcf71ce3          	bne	a4,a5,80005bf0 <consoleintr+0xe8>
    80005c1c:	6902                	ld	s2,0(sp)
    80005c1e:	b715                	j	80005b42 <consoleintr+0x3a>
    80005c20:	6902                	ld	s2,0(sp)
    80005c22:	b705                	j	80005b42 <consoleintr+0x3a>
    80005c24:	6902                	ld	s2,0(sp)
    80005c26:	bf31                	j	80005b42 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c28:	0001c717          	auipc	a4,0x1c
    80005c2c:	04870713          	add	a4,a4,72 # 80021c70 <cons>
    80005c30:	0a072783          	lw	a5,160(a4)
    80005c34:	09c72703          	lw	a4,156(a4)
    80005c38:	f0f705e3          	beq	a4,a5,80005b42 <consoleintr+0x3a>
      cons.e--;
    80005c3c:	37fd                	addw	a5,a5,-1
    80005c3e:	0001c717          	auipc	a4,0x1c
    80005c42:	0cf72923          	sw	a5,210(a4) # 80021d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	e7c080e7          	jalr	-388(ra) # 80005ac6 <consputc>
    80005c52:	bdc5                	j	80005b42 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c54:	ee0487e3          	beqz	s1,80005b42 <consoleintr+0x3a>
    80005c58:	b731                	j	80005b64 <consoleintr+0x5c>
      consputc(c);
    80005c5a:	4529                	li	a0,10
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	e6a080e7          	jalr	-406(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c64:	0001c797          	auipc	a5,0x1c
    80005c68:	00c78793          	add	a5,a5,12 # 80021c70 <cons>
    80005c6c:	0a07a703          	lw	a4,160(a5)
    80005c70:	0017069b          	addw	a3,a4,1
    80005c74:	0006861b          	sext.w	a2,a3
    80005c78:	0ad7a023          	sw	a3,160(a5)
    80005c7c:	07f77713          	and	a4,a4,127
    80005c80:	97ba                	add	a5,a5,a4
    80005c82:	4729                	li	a4,10
    80005c84:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c88:	0001c797          	auipc	a5,0x1c
    80005c8c:	08c7a223          	sw	a2,132(a5) # 80021d0c <cons+0x9c>
        wakeup(&cons.r);
    80005c90:	0001c517          	auipc	a0,0x1c
    80005c94:	07850513          	add	a0,a0,120 # 80021d08 <cons+0x98>
    80005c98:	ffffc097          	auipc	ra,0xffffc
    80005c9c:	980080e7          	jalr	-1664(ra) # 80001618 <wakeup>
    80005ca0:	b54d                	j	80005b42 <consoleintr+0x3a>

0000000080005ca2 <consoleinit>:

void
consoleinit(void)
{
    80005ca2:	1141                	add	sp,sp,-16
    80005ca4:	e406                	sd	ra,8(sp)
    80005ca6:	e022                	sd	s0,0(sp)
    80005ca8:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005caa:	00003597          	auipc	a1,0x3
    80005cae:	a5e58593          	add	a1,a1,-1442 # 80008708 <etext+0x708>
    80005cb2:	0001c517          	auipc	a0,0x1c
    80005cb6:	fbe50513          	add	a0,a0,-66 # 80021c70 <cons>
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	5c2080e7          	jalr	1474(ra) # 8000627c <initlock>

  uartinit();
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	354080e7          	jalr	852(ra) # 80006016 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cca:	00013797          	auipc	a5,0x13
    80005cce:	cce78793          	add	a5,a5,-818 # 80018998 <devsw>
    80005cd2:	00000717          	auipc	a4,0x0
    80005cd6:	cce70713          	add	a4,a4,-818 # 800059a0 <consoleread>
    80005cda:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cdc:	00000717          	auipc	a4,0x0
    80005ce0:	c5670713          	add	a4,a4,-938 # 80005932 <consolewrite>
    80005ce4:	ef98                	sd	a4,24(a5)
}
    80005ce6:	60a2                	ld	ra,8(sp)
    80005ce8:	6402                	ld	s0,0(sp)
    80005cea:	0141                	add	sp,sp,16
    80005cec:	8082                	ret

0000000080005cee <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cee:	7179                	add	sp,sp,-48
    80005cf0:	f406                	sd	ra,40(sp)
    80005cf2:	f022                	sd	s0,32(sp)
    80005cf4:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cf6:	c219                	beqz	a2,80005cfc <printint+0xe>
    80005cf8:	08054963          	bltz	a0,80005d8a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cfc:	2501                	sext.w	a0,a0
    80005cfe:	4881                	li	a7,0
    80005d00:	fd040693          	add	a3,s0,-48

  i = 0;
    80005d04:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d06:	2581                	sext.w	a1,a1
    80005d08:	00003617          	auipc	a2,0x3
    80005d0c:	b6060613          	add	a2,a2,-1184 # 80008868 <digits>
    80005d10:	883a                	mv	a6,a4
    80005d12:	2705                	addw	a4,a4,1
    80005d14:	02b577bb          	remuw	a5,a0,a1
    80005d18:	1782                	sll	a5,a5,0x20
    80005d1a:	9381                	srl	a5,a5,0x20
    80005d1c:	97b2                	add	a5,a5,a2
    80005d1e:	0007c783          	lbu	a5,0(a5)
    80005d22:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d26:	0005079b          	sext.w	a5,a0
    80005d2a:	02b5553b          	divuw	a0,a0,a1
    80005d2e:	0685                	add	a3,a3,1
    80005d30:	feb7f0e3          	bgeu	a5,a1,80005d10 <printint+0x22>

  if(sign)
    80005d34:	00088c63          	beqz	a7,80005d4c <printint+0x5e>
    buf[i++] = '-';
    80005d38:	fe070793          	add	a5,a4,-32
    80005d3c:	00878733          	add	a4,a5,s0
    80005d40:	02d00793          	li	a5,45
    80005d44:	fef70823          	sb	a5,-16(a4)
    80005d48:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005d4c:	02e05b63          	blez	a4,80005d82 <printint+0x94>
    80005d50:	ec26                	sd	s1,24(sp)
    80005d52:	e84a                	sd	s2,16(sp)
    80005d54:	fd040793          	add	a5,s0,-48
    80005d58:	00e784b3          	add	s1,a5,a4
    80005d5c:	fff78913          	add	s2,a5,-1
    80005d60:	993a                	add	s2,s2,a4
    80005d62:	377d                	addw	a4,a4,-1
    80005d64:	1702                	sll	a4,a4,0x20
    80005d66:	9301                	srl	a4,a4,0x20
    80005d68:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d6c:	fff4c503          	lbu	a0,-1(s1)
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	d56080e7          	jalr	-682(ra) # 80005ac6 <consputc>
  while(--i >= 0)
    80005d78:	14fd                	add	s1,s1,-1
    80005d7a:	ff2499e3          	bne	s1,s2,80005d6c <printint+0x7e>
    80005d7e:	64e2                	ld	s1,24(sp)
    80005d80:	6942                	ld	s2,16(sp)
}
    80005d82:	70a2                	ld	ra,40(sp)
    80005d84:	7402                	ld	s0,32(sp)
    80005d86:	6145                	add	sp,sp,48
    80005d88:	8082                	ret
    x = -xx;
    80005d8a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d8e:	4885                	li	a7,1
    x = -xx;
    80005d90:	bf85                	j	80005d00 <printint+0x12>

0000000080005d92 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d92:	1101                	add	sp,sp,-32
    80005d94:	ec06                	sd	ra,24(sp)
    80005d96:	e822                	sd	s0,16(sp)
    80005d98:	e426                	sd	s1,8(sp)
    80005d9a:	1000                	add	s0,sp,32
    80005d9c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d9e:	0001c797          	auipc	a5,0x1c
    80005da2:	f807a923          	sw	zero,-110(a5) # 80021d30 <pr+0x18>
  printf("panic: ");
    80005da6:	00003517          	auipc	a0,0x3
    80005daa:	96a50513          	add	a0,a0,-1686 # 80008710 <etext+0x710>
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	02e080e7          	jalr	46(ra) # 80005ddc <printf>
  printf(s);
    80005db6:	8526                	mv	a0,s1
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	024080e7          	jalr	36(ra) # 80005ddc <printf>
  printf("\n");
    80005dc0:	00002517          	auipc	a0,0x2
    80005dc4:	25850513          	add	a0,a0,600 # 80008018 <etext+0x18>
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	014080e7          	jalr	20(ra) # 80005ddc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dd0:	4785                	li	a5,1
    80005dd2:	00003717          	auipc	a4,0x3
    80005dd6:	b0f72d23          	sw	a5,-1254(a4) # 800088ec <panicked>
  for(;;)
    80005dda:	a001                	j	80005dda <panic+0x48>

0000000080005ddc <printf>:
{
    80005ddc:	7131                	add	sp,sp,-192
    80005dde:	fc86                	sd	ra,120(sp)
    80005de0:	f8a2                	sd	s0,112(sp)
    80005de2:	e8d2                	sd	s4,80(sp)
    80005de4:	f06a                	sd	s10,32(sp)
    80005de6:	0100                	add	s0,sp,128
    80005de8:	8a2a                	mv	s4,a0
    80005dea:	e40c                	sd	a1,8(s0)
    80005dec:	e810                	sd	a2,16(s0)
    80005dee:	ec14                	sd	a3,24(s0)
    80005df0:	f018                	sd	a4,32(s0)
    80005df2:	f41c                	sd	a5,40(s0)
    80005df4:	03043823          	sd	a6,48(s0)
    80005df8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dfc:	0001cd17          	auipc	s10,0x1c
    80005e00:	f34d2d03          	lw	s10,-204(s10) # 80021d30 <pr+0x18>
  if(locking)
    80005e04:	040d1463          	bnez	s10,80005e4c <printf+0x70>
  if (fmt == 0)
    80005e08:	040a0b63          	beqz	s4,80005e5e <printf+0x82>
  va_start(ap, fmt);
    80005e0c:	00840793          	add	a5,s0,8
    80005e10:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e14:	000a4503          	lbu	a0,0(s4)
    80005e18:	18050b63          	beqz	a0,80005fae <printf+0x1d2>
    80005e1c:	f4a6                	sd	s1,104(sp)
    80005e1e:	f0ca                	sd	s2,96(sp)
    80005e20:	ecce                	sd	s3,88(sp)
    80005e22:	e4d6                	sd	s5,72(sp)
    80005e24:	e0da                	sd	s6,64(sp)
    80005e26:	fc5e                	sd	s7,56(sp)
    80005e28:	f862                	sd	s8,48(sp)
    80005e2a:	f466                	sd	s9,40(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	4981                	li	s3,0
    if(c != '%'){
    80005e30:	02500b13          	li	s6,37
    switch(c){
    80005e34:	07000b93          	li	s7,112
  consputc('x');
    80005e38:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e3a:	00003a97          	auipc	s5,0x3
    80005e3e:	a2ea8a93          	add	s5,s5,-1490 # 80008868 <digits>
    switch(c){
    80005e42:	07300c13          	li	s8,115
    80005e46:	06400d93          	li	s11,100
    80005e4a:	a0b1                	j	80005e96 <printf+0xba>
    acquire(&pr.lock);
    80005e4c:	0001c517          	auipc	a0,0x1c
    80005e50:	ecc50513          	add	a0,a0,-308 # 80021d18 <pr>
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	4b8080e7          	jalr	1208(ra) # 8000630c <acquire>
    80005e5c:	b775                	j	80005e08 <printf+0x2c>
    80005e5e:	f4a6                	sd	s1,104(sp)
    80005e60:	f0ca                	sd	s2,96(sp)
    80005e62:	ecce                	sd	s3,88(sp)
    80005e64:	e4d6                	sd	s5,72(sp)
    80005e66:	e0da                	sd	s6,64(sp)
    80005e68:	fc5e                	sd	s7,56(sp)
    80005e6a:	f862                	sd	s8,48(sp)
    80005e6c:	f466                	sd	s9,40(sp)
    80005e6e:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e70:	00003517          	auipc	a0,0x3
    80005e74:	8b050513          	add	a0,a0,-1872 # 80008720 <etext+0x720>
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	f1a080e7          	jalr	-230(ra) # 80005d92 <panic>
      consputc(c);
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	c46080e7          	jalr	-954(ra) # 80005ac6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e88:	2985                	addw	s3,s3,1
    80005e8a:	013a07b3          	add	a5,s4,s3
    80005e8e:	0007c503          	lbu	a0,0(a5)
    80005e92:	10050563          	beqz	a0,80005f9c <printf+0x1c0>
    if(c != '%'){
    80005e96:	ff6515e3          	bne	a0,s6,80005e80 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005e9a:	2985                	addw	s3,s3,1
    80005e9c:	013a07b3          	add	a5,s4,s3
    80005ea0:	0007c783          	lbu	a5,0(a5)
    80005ea4:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ea8:	10078b63          	beqz	a5,80005fbe <printf+0x1e2>
    switch(c){
    80005eac:	05778a63          	beq	a5,s7,80005f00 <printf+0x124>
    80005eb0:	02fbf663          	bgeu	s7,a5,80005edc <printf+0x100>
    80005eb4:	09878863          	beq	a5,s8,80005f44 <printf+0x168>
    80005eb8:	07800713          	li	a4,120
    80005ebc:	0ce79563          	bne	a5,a4,80005f86 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005ec0:	f8843783          	ld	a5,-120(s0)
    80005ec4:	00878713          	add	a4,a5,8
    80005ec8:	f8e43423          	sd	a4,-120(s0)
    80005ecc:	4605                	li	a2,1
    80005ece:	85e6                	mv	a1,s9
    80005ed0:	4388                	lw	a0,0(a5)
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	e1c080e7          	jalr	-484(ra) # 80005cee <printint>
      break;
    80005eda:	b77d                	j	80005e88 <printf+0xac>
    switch(c){
    80005edc:	09678f63          	beq	a5,s6,80005f7a <printf+0x19e>
    80005ee0:	0bb79363          	bne	a5,s11,80005f86 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005ee4:	f8843783          	ld	a5,-120(s0)
    80005ee8:	00878713          	add	a4,a5,8
    80005eec:	f8e43423          	sd	a4,-120(s0)
    80005ef0:	4605                	li	a2,1
    80005ef2:	45a9                	li	a1,10
    80005ef4:	4388                	lw	a0,0(a5)
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	df8080e7          	jalr	-520(ra) # 80005cee <printint>
      break;
    80005efe:	b769                	j	80005e88 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005f00:	f8843783          	ld	a5,-120(s0)
    80005f04:	00878713          	add	a4,a5,8
    80005f08:	f8e43423          	sd	a4,-120(s0)
    80005f0c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f10:	03000513          	li	a0,48
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	bb2080e7          	jalr	-1102(ra) # 80005ac6 <consputc>
  consputc('x');
    80005f1c:	07800513          	li	a0,120
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	ba6080e7          	jalr	-1114(ra) # 80005ac6 <consputc>
    80005f28:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f2a:	03c95793          	srl	a5,s2,0x3c
    80005f2e:	97d6                	add	a5,a5,s5
    80005f30:	0007c503          	lbu	a0,0(a5)
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b92080e7          	jalr	-1134(ra) # 80005ac6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f3c:	0912                	sll	s2,s2,0x4
    80005f3e:	34fd                	addw	s1,s1,-1
    80005f40:	f4ed                	bnez	s1,80005f2a <printf+0x14e>
    80005f42:	b799                	j	80005e88 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f44:	f8843783          	ld	a5,-120(s0)
    80005f48:	00878713          	add	a4,a5,8
    80005f4c:	f8e43423          	sd	a4,-120(s0)
    80005f50:	6384                	ld	s1,0(a5)
    80005f52:	cc89                	beqz	s1,80005f6c <printf+0x190>
      for(; *s; s++)
    80005f54:	0004c503          	lbu	a0,0(s1)
    80005f58:	d905                	beqz	a0,80005e88 <printf+0xac>
        consputc(*s);
    80005f5a:	00000097          	auipc	ra,0x0
    80005f5e:	b6c080e7          	jalr	-1172(ra) # 80005ac6 <consputc>
      for(; *s; s++)
    80005f62:	0485                	add	s1,s1,1
    80005f64:	0004c503          	lbu	a0,0(s1)
    80005f68:	f96d                	bnez	a0,80005f5a <printf+0x17e>
    80005f6a:	bf39                	j	80005e88 <printf+0xac>
        s = "(null)";
    80005f6c:	00002497          	auipc	s1,0x2
    80005f70:	7ac48493          	add	s1,s1,1964 # 80008718 <etext+0x718>
      for(; *s; s++)
    80005f74:	02800513          	li	a0,40
    80005f78:	b7cd                	j	80005f5a <printf+0x17e>
      consputc('%');
    80005f7a:	855a                	mv	a0,s6
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	b4a080e7          	jalr	-1206(ra) # 80005ac6 <consputc>
      break;
    80005f84:	b711                	j	80005e88 <printf+0xac>
      consputc('%');
    80005f86:	855a                	mv	a0,s6
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	b3e080e7          	jalr	-1218(ra) # 80005ac6 <consputc>
      consputc(c);
    80005f90:	8526                	mv	a0,s1
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	b34080e7          	jalr	-1228(ra) # 80005ac6 <consputc>
      break;
    80005f9a:	b5fd                	j	80005e88 <printf+0xac>
    80005f9c:	74a6                	ld	s1,104(sp)
    80005f9e:	7906                	ld	s2,96(sp)
    80005fa0:	69e6                	ld	s3,88(sp)
    80005fa2:	6aa6                	ld	s5,72(sp)
    80005fa4:	6b06                	ld	s6,64(sp)
    80005fa6:	7be2                	ld	s7,56(sp)
    80005fa8:	7c42                	ld	s8,48(sp)
    80005faa:	7ca2                	ld	s9,40(sp)
    80005fac:	6de2                	ld	s11,24(sp)
  if(locking)
    80005fae:	020d1263          	bnez	s10,80005fd2 <printf+0x1f6>
}
    80005fb2:	70e6                	ld	ra,120(sp)
    80005fb4:	7446                	ld	s0,112(sp)
    80005fb6:	6a46                	ld	s4,80(sp)
    80005fb8:	7d02                	ld	s10,32(sp)
    80005fba:	6129                	add	sp,sp,192
    80005fbc:	8082                	ret
    80005fbe:	74a6                	ld	s1,104(sp)
    80005fc0:	7906                	ld	s2,96(sp)
    80005fc2:	69e6                	ld	s3,88(sp)
    80005fc4:	6aa6                	ld	s5,72(sp)
    80005fc6:	6b06                	ld	s6,64(sp)
    80005fc8:	7be2                	ld	s7,56(sp)
    80005fca:	7c42                	ld	s8,48(sp)
    80005fcc:	7ca2                	ld	s9,40(sp)
    80005fce:	6de2                	ld	s11,24(sp)
    80005fd0:	bff9                	j	80005fae <printf+0x1d2>
    release(&pr.lock);
    80005fd2:	0001c517          	auipc	a0,0x1c
    80005fd6:	d4650513          	add	a0,a0,-698 # 80021d18 <pr>
    80005fda:	00000097          	auipc	ra,0x0
    80005fde:	3e6080e7          	jalr	998(ra) # 800063c0 <release>
}
    80005fe2:	bfc1                	j	80005fb2 <printf+0x1d6>

0000000080005fe4 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fe4:	1101                	add	sp,sp,-32
    80005fe6:	ec06                	sd	ra,24(sp)
    80005fe8:	e822                	sd	s0,16(sp)
    80005fea:	e426                	sd	s1,8(sp)
    80005fec:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fee:	0001c497          	auipc	s1,0x1c
    80005ff2:	d2a48493          	add	s1,s1,-726 # 80021d18 <pr>
    80005ff6:	00002597          	auipc	a1,0x2
    80005ffa:	73a58593          	add	a1,a1,1850 # 80008730 <etext+0x730>
    80005ffe:	8526                	mv	a0,s1
    80006000:	00000097          	auipc	ra,0x0
    80006004:	27c080e7          	jalr	636(ra) # 8000627c <initlock>
  pr.locking = 1;
    80006008:	4785                	li	a5,1
    8000600a:	cc9c                	sw	a5,24(s1)
}
    8000600c:	60e2                	ld	ra,24(sp)
    8000600e:	6442                	ld	s0,16(sp)
    80006010:	64a2                	ld	s1,8(sp)
    80006012:	6105                	add	sp,sp,32
    80006014:	8082                	ret

0000000080006016 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006016:	1141                	add	sp,sp,-16
    80006018:	e406                	sd	ra,8(sp)
    8000601a:	e022                	sd	s0,0(sp)
    8000601c:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000601e:	100007b7          	lui	a5,0x10000
    80006022:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006026:	10000737          	lui	a4,0x10000
    8000602a:	f8000693          	li	a3,-128
    8000602e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006032:	468d                	li	a3,3
    80006034:	10000637          	lui	a2,0x10000
    80006038:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000603c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006040:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006044:	10000737          	lui	a4,0x10000
    80006048:	461d                	li	a2,7
    8000604a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000604e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006052:	00002597          	auipc	a1,0x2
    80006056:	6e658593          	add	a1,a1,1766 # 80008738 <etext+0x738>
    8000605a:	0001c517          	auipc	a0,0x1c
    8000605e:	cde50513          	add	a0,a0,-802 # 80021d38 <uart_tx_lock>
    80006062:	00000097          	auipc	ra,0x0
    80006066:	21a080e7          	jalr	538(ra) # 8000627c <initlock>
}
    8000606a:	60a2                	ld	ra,8(sp)
    8000606c:	6402                	ld	s0,0(sp)
    8000606e:	0141                	add	sp,sp,16
    80006070:	8082                	ret

0000000080006072 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006072:	1101                	add	sp,sp,-32
    80006074:	ec06                	sd	ra,24(sp)
    80006076:	e822                	sd	s0,16(sp)
    80006078:	e426                	sd	s1,8(sp)
    8000607a:	1000                	add	s0,sp,32
    8000607c:	84aa                	mv	s1,a0
  push_off();
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	242080e7          	jalr	578(ra) # 800062c0 <push_off>

  if(panicked){
    80006086:	00003797          	auipc	a5,0x3
    8000608a:	8667a783          	lw	a5,-1946(a5) # 800088ec <panicked>
    8000608e:	eb85                	bnez	a5,800060be <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006090:	10000737          	lui	a4,0x10000
    80006094:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006096:	00074783          	lbu	a5,0(a4)
    8000609a:	0207f793          	and	a5,a5,32
    8000609e:	dfe5                	beqz	a5,80006096 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060a0:	0ff4f513          	zext.b	a0,s1
    800060a4:	100007b7          	lui	a5,0x10000
    800060a8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	2b4080e7          	jalr	692(ra) # 80006360 <pop_off>
}
    800060b4:	60e2                	ld	ra,24(sp)
    800060b6:	6442                	ld	s0,16(sp)
    800060b8:	64a2                	ld	s1,8(sp)
    800060ba:	6105                	add	sp,sp,32
    800060bc:	8082                	ret
    for(;;)
    800060be:	a001                	j	800060be <uartputc_sync+0x4c>

00000000800060c0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060c0:	00003797          	auipc	a5,0x3
    800060c4:	8307b783          	ld	a5,-2000(a5) # 800088f0 <uart_tx_r>
    800060c8:	00003717          	auipc	a4,0x3
    800060cc:	83073703          	ld	a4,-2000(a4) # 800088f8 <uart_tx_w>
    800060d0:	06f70f63          	beq	a4,a5,8000614e <uartstart+0x8e>
{
    800060d4:	7139                	add	sp,sp,-64
    800060d6:	fc06                	sd	ra,56(sp)
    800060d8:	f822                	sd	s0,48(sp)
    800060da:	f426                	sd	s1,40(sp)
    800060dc:	f04a                	sd	s2,32(sp)
    800060de:	ec4e                	sd	s3,24(sp)
    800060e0:	e852                	sd	s4,16(sp)
    800060e2:	e456                	sd	s5,8(sp)
    800060e4:	e05a                	sd	s6,0(sp)
    800060e6:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060e8:	10000937          	lui	s2,0x10000
    800060ec:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ee:	0001ca97          	auipc	s5,0x1c
    800060f2:	c4aa8a93          	add	s5,s5,-950 # 80021d38 <uart_tx_lock>
    uart_tx_r += 1;
    800060f6:	00002497          	auipc	s1,0x2
    800060fa:	7fa48493          	add	s1,s1,2042 # 800088f0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800060fe:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006102:	00002997          	auipc	s3,0x2
    80006106:	7f698993          	add	s3,s3,2038 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000610a:	00094703          	lbu	a4,0(s2)
    8000610e:	02077713          	and	a4,a4,32
    80006112:	c705                	beqz	a4,8000613a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006114:	01f7f713          	and	a4,a5,31
    80006118:	9756                	add	a4,a4,s5
    8000611a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000611e:	0785                	add	a5,a5,1
    80006120:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006122:	8526                	mv	a0,s1
    80006124:	ffffb097          	auipc	ra,0xffffb
    80006128:	4f4080e7          	jalr	1268(ra) # 80001618 <wakeup>
    WriteReg(THR, c);
    8000612c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006130:	609c                	ld	a5,0(s1)
    80006132:	0009b703          	ld	a4,0(s3)
    80006136:	fcf71ae3          	bne	a4,a5,8000610a <uartstart+0x4a>
  }
}
    8000613a:	70e2                	ld	ra,56(sp)
    8000613c:	7442                	ld	s0,48(sp)
    8000613e:	74a2                	ld	s1,40(sp)
    80006140:	7902                	ld	s2,32(sp)
    80006142:	69e2                	ld	s3,24(sp)
    80006144:	6a42                	ld	s4,16(sp)
    80006146:	6aa2                	ld	s5,8(sp)
    80006148:	6b02                	ld	s6,0(sp)
    8000614a:	6121                	add	sp,sp,64
    8000614c:	8082                	ret
    8000614e:	8082                	ret

0000000080006150 <uartputc>:
{
    80006150:	7179                	add	sp,sp,-48
    80006152:	f406                	sd	ra,40(sp)
    80006154:	f022                	sd	s0,32(sp)
    80006156:	ec26                	sd	s1,24(sp)
    80006158:	e84a                	sd	s2,16(sp)
    8000615a:	e44e                	sd	s3,8(sp)
    8000615c:	e052                	sd	s4,0(sp)
    8000615e:	1800                	add	s0,sp,48
    80006160:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006162:	0001c517          	auipc	a0,0x1c
    80006166:	bd650513          	add	a0,a0,-1066 # 80021d38 <uart_tx_lock>
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	1a2080e7          	jalr	418(ra) # 8000630c <acquire>
  if(panicked){
    80006172:	00002797          	auipc	a5,0x2
    80006176:	77a7a783          	lw	a5,1914(a5) # 800088ec <panicked>
    8000617a:	e7c9                	bnez	a5,80006204 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000617c:	00002717          	auipc	a4,0x2
    80006180:	77c73703          	ld	a4,1916(a4) # 800088f8 <uart_tx_w>
    80006184:	00002797          	auipc	a5,0x2
    80006188:	76c7b783          	ld	a5,1900(a5) # 800088f0 <uart_tx_r>
    8000618c:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006190:	0001c997          	auipc	s3,0x1c
    80006194:	ba898993          	add	s3,s3,-1112 # 80021d38 <uart_tx_lock>
    80006198:	00002497          	auipc	s1,0x2
    8000619c:	75848493          	add	s1,s1,1880 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a0:	00002917          	auipc	s2,0x2
    800061a4:	75890913          	add	s2,s2,1880 # 800088f8 <uart_tx_w>
    800061a8:	00e79f63          	bne	a5,a4,800061c6 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800061ac:	85ce                	mv	a1,s3
    800061ae:	8526                	mv	a0,s1
    800061b0:	ffffb097          	auipc	ra,0xffffb
    800061b4:	404080e7          	jalr	1028(ra) # 800015b4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061b8:	00093703          	ld	a4,0(s2)
    800061bc:	609c                	ld	a5,0(s1)
    800061be:	02078793          	add	a5,a5,32
    800061c2:	fee785e3          	beq	a5,a4,800061ac <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061c6:	0001c497          	auipc	s1,0x1c
    800061ca:	b7248493          	add	s1,s1,-1166 # 80021d38 <uart_tx_lock>
    800061ce:	01f77793          	and	a5,a4,31
    800061d2:	97a6                	add	a5,a5,s1
    800061d4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800061d8:	0705                	add	a4,a4,1
    800061da:	00002797          	auipc	a5,0x2
    800061de:	70e7bf23          	sd	a4,1822(a5) # 800088f8 <uart_tx_w>
  uartstart();
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	ede080e7          	jalr	-290(ra) # 800060c0 <uartstart>
  release(&uart_tx_lock);
    800061ea:	8526                	mv	a0,s1
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	1d4080e7          	jalr	468(ra) # 800063c0 <release>
}
    800061f4:	70a2                	ld	ra,40(sp)
    800061f6:	7402                	ld	s0,32(sp)
    800061f8:	64e2                	ld	s1,24(sp)
    800061fa:	6942                	ld	s2,16(sp)
    800061fc:	69a2                	ld	s3,8(sp)
    800061fe:	6a02                	ld	s4,0(sp)
    80006200:	6145                	add	sp,sp,48
    80006202:	8082                	ret
    for(;;)
    80006204:	a001                	j	80006204 <uartputc+0xb4>

0000000080006206 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006206:	1141                	add	sp,sp,-16
    80006208:	e422                	sd	s0,8(sp)
    8000620a:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000620c:	100007b7          	lui	a5,0x10000
    80006210:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006212:	0007c783          	lbu	a5,0(a5)
    80006216:	8b85                	and	a5,a5,1
    80006218:	cb81                	beqz	a5,80006228 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000621a:	100007b7          	lui	a5,0x10000
    8000621e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006222:	6422                	ld	s0,8(sp)
    80006224:	0141                	add	sp,sp,16
    80006226:	8082                	ret
    return -1;
    80006228:	557d                	li	a0,-1
    8000622a:	bfe5                	j	80006222 <uartgetc+0x1c>

000000008000622c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000622c:	1101                	add	sp,sp,-32
    8000622e:	ec06                	sd	ra,24(sp)
    80006230:	e822                	sd	s0,16(sp)
    80006232:	e426                	sd	s1,8(sp)
    80006234:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006236:	54fd                	li	s1,-1
    80006238:	a029                	j	80006242 <uartintr+0x16>
      break;
    consoleintr(c);
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	8ce080e7          	jalr	-1842(ra) # 80005b08 <consoleintr>
    int c = uartgetc();
    80006242:	00000097          	auipc	ra,0x0
    80006246:	fc4080e7          	jalr	-60(ra) # 80006206 <uartgetc>
    if(c == -1)
    8000624a:	fe9518e3          	bne	a0,s1,8000623a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000624e:	0001c497          	auipc	s1,0x1c
    80006252:	aea48493          	add	s1,s1,-1302 # 80021d38 <uart_tx_lock>
    80006256:	8526                	mv	a0,s1
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	0b4080e7          	jalr	180(ra) # 8000630c <acquire>
  uartstart();
    80006260:	00000097          	auipc	ra,0x0
    80006264:	e60080e7          	jalr	-416(ra) # 800060c0 <uartstart>
  release(&uart_tx_lock);
    80006268:	8526                	mv	a0,s1
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	156080e7          	jalr	342(ra) # 800063c0 <release>
}
    80006272:	60e2                	ld	ra,24(sp)
    80006274:	6442                	ld	s0,16(sp)
    80006276:	64a2                	ld	s1,8(sp)
    80006278:	6105                	add	sp,sp,32
    8000627a:	8082                	ret

000000008000627c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000627c:	1141                	add	sp,sp,-16
    8000627e:	e422                	sd	s0,8(sp)
    80006280:	0800                	add	s0,sp,16
  lk->name = name;
    80006282:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006284:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006288:	00053823          	sd	zero,16(a0)
}
    8000628c:	6422                	ld	s0,8(sp)
    8000628e:	0141                	add	sp,sp,16
    80006290:	8082                	ret

0000000080006292 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006292:	411c                	lw	a5,0(a0)
    80006294:	e399                	bnez	a5,8000629a <holding+0x8>
    80006296:	4501                	li	a0,0
  return r;
}
    80006298:	8082                	ret
{
    8000629a:	1101                	add	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062a4:	6904                	ld	s1,16(a0)
    800062a6:	ffffb097          	auipc	ra,0xffffb
    800062aa:	c44080e7          	jalr	-956(ra) # 80000eea <mycpu>
    800062ae:	40a48533          	sub	a0,s1,a0
    800062b2:	00153513          	seqz	a0,a0
}
    800062b6:	60e2                	ld	ra,24(sp)
    800062b8:	6442                	ld	s0,16(sp)
    800062ba:	64a2                	ld	s1,8(sp)
    800062bc:	6105                	add	sp,sp,32
    800062be:	8082                	ret

00000000800062c0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c0:	1101                	add	sp,sp,-32
    800062c2:	ec06                	sd	ra,24(sp)
    800062c4:	e822                	sd	s0,16(sp)
    800062c6:	e426                	sd	s1,8(sp)
    800062c8:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ca:	100024f3          	csrr	s1,sstatus
    800062ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062d4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062d8:	ffffb097          	auipc	ra,0xffffb
    800062dc:	c12080e7          	jalr	-1006(ra) # 80000eea <mycpu>
    800062e0:	5d3c                	lw	a5,120(a0)
    800062e2:	cf89                	beqz	a5,800062fc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062e4:	ffffb097          	auipc	ra,0xffffb
    800062e8:	c06080e7          	jalr	-1018(ra) # 80000eea <mycpu>
    800062ec:	5d3c                	lw	a5,120(a0)
    800062ee:	2785                	addw	a5,a5,1
    800062f0:	dd3c                	sw	a5,120(a0)
}
    800062f2:	60e2                	ld	ra,24(sp)
    800062f4:	6442                	ld	s0,16(sp)
    800062f6:	64a2                	ld	s1,8(sp)
    800062f8:	6105                	add	sp,sp,32
    800062fa:	8082                	ret
    mycpu()->intena = old;
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	bee080e7          	jalr	-1042(ra) # 80000eea <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006304:	8085                	srl	s1,s1,0x1
    80006306:	8885                	and	s1,s1,1
    80006308:	dd64                	sw	s1,124(a0)
    8000630a:	bfe9                	j	800062e4 <push_off+0x24>

000000008000630c <acquire>:
{
    8000630c:	1101                	add	sp,sp,-32
    8000630e:	ec06                	sd	ra,24(sp)
    80006310:	e822                	sd	s0,16(sp)
    80006312:	e426                	sd	s1,8(sp)
    80006314:	1000                	add	s0,sp,32
    80006316:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	fa8080e7          	jalr	-88(ra) # 800062c0 <push_off>
  if(holding(lk))
    80006320:	8526                	mv	a0,s1
    80006322:	00000097          	auipc	ra,0x0
    80006326:	f70080e7          	jalr	-144(ra) # 80006292 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000632a:	4705                	li	a4,1
  if(holding(lk))
    8000632c:	e115                	bnez	a0,80006350 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000632e:	87ba                	mv	a5,a4
    80006330:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006334:	2781                	sext.w	a5,a5
    80006336:	ffe5                	bnez	a5,8000632e <acquire+0x22>
  __sync_synchronize();
    80006338:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000633c:	ffffb097          	auipc	ra,0xffffb
    80006340:	bae080e7          	jalr	-1106(ra) # 80000eea <mycpu>
    80006344:	e888                	sd	a0,16(s1)
}
    80006346:	60e2                	ld	ra,24(sp)
    80006348:	6442                	ld	s0,16(sp)
    8000634a:	64a2                	ld	s1,8(sp)
    8000634c:	6105                	add	sp,sp,32
    8000634e:	8082                	ret
    panic("acquire");
    80006350:	00002517          	auipc	a0,0x2
    80006354:	3f050513          	add	a0,a0,1008 # 80008740 <etext+0x740>
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	a3a080e7          	jalr	-1478(ra) # 80005d92 <panic>

0000000080006360 <pop_off>:

void
pop_off(void)
{
    80006360:	1141                	add	sp,sp,-16
    80006362:	e406                	sd	ra,8(sp)
    80006364:	e022                	sd	s0,0(sp)
    80006366:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80006368:	ffffb097          	auipc	ra,0xffffb
    8000636c:	b82080e7          	jalr	-1150(ra) # 80000eea <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006370:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006374:	8b89                	and	a5,a5,2
  if(intr_get())
    80006376:	e78d                	bnez	a5,800063a0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006378:	5d3c                	lw	a5,120(a0)
    8000637a:	02f05b63          	blez	a5,800063b0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000637e:	37fd                	addw	a5,a5,-1
    80006380:	0007871b          	sext.w	a4,a5
    80006384:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006386:	eb09                	bnez	a4,80006398 <pop_off+0x38>
    80006388:	5d7c                	lw	a5,124(a0)
    8000638a:	c799                	beqz	a5,80006398 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000638c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006390:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006394:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006398:	60a2                	ld	ra,8(sp)
    8000639a:	6402                	ld	s0,0(sp)
    8000639c:	0141                	add	sp,sp,16
    8000639e:	8082                	ret
    panic("pop_off - interruptible");
    800063a0:	00002517          	auipc	a0,0x2
    800063a4:	3a850513          	add	a0,a0,936 # 80008748 <etext+0x748>
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	9ea080e7          	jalr	-1558(ra) # 80005d92 <panic>
    panic("pop_off");
    800063b0:	00002517          	auipc	a0,0x2
    800063b4:	3b050513          	add	a0,a0,944 # 80008760 <etext+0x760>
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	9da080e7          	jalr	-1574(ra) # 80005d92 <panic>

00000000800063c0 <release>:
{
    800063c0:	1101                	add	sp,sp,-32
    800063c2:	ec06                	sd	ra,24(sp)
    800063c4:	e822                	sd	s0,16(sp)
    800063c6:	e426                	sd	s1,8(sp)
    800063c8:	1000                	add	s0,sp,32
    800063ca:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063cc:	00000097          	auipc	ra,0x0
    800063d0:	ec6080e7          	jalr	-314(ra) # 80006292 <holding>
    800063d4:	c115                	beqz	a0,800063f8 <release+0x38>
  lk->cpu = 0;
    800063d6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063da:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063de:	0f50000f          	fence	iorw,ow
    800063e2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	f7a080e7          	jalr	-134(ra) # 80006360 <pop_off>
}
    800063ee:	60e2                	ld	ra,24(sp)
    800063f0:	6442                	ld	s0,16(sp)
    800063f2:	64a2                	ld	s1,8(sp)
    800063f4:	6105                	add	sp,sp,32
    800063f6:	8082                	ret
    panic("release");
    800063f8:	00002517          	auipc	a0,0x2
    800063fc:	37050513          	add	a0,a0,880 # 80008768 <etext+0x768>
    80006400:	00000097          	auipc	ra,0x0
    80006404:	992080e7          	jalr	-1646(ra) # 80005d92 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
